import std.conv : to;
import std.stdio;
import std.typecons : Tuple;

import bindbc.glfw;
import gfm.math;
import wgpu.api;
import examples.math;
import examples.window;

// Adapted from https://github.com/gfx-rs/wgpu-rs/blob/8aaab84c5b27f0382be7dbced5b178b4e219edd3/examples/cube/main.rs

package:

struct Vertex {
  vec3f position;
  alias position this;

  this(float[3] position) { this.position = position; }
  this(float x, float y, float z) { position = [x, y, z]; }
}

alias Mesh = Tuple!(Vertex[], "vertices", ushort[], "indices");
Mesh unitCube() {
  auto vertices = [
    // top (0, 0, 1)
    Vertex([-1, -1, 1]),
    Vertex([1, -1, 1]),
    Vertex([1, 1, 1]),
    Vertex([-1, 1, 1]),
    // bottom (0, 0, -1)
    Vertex([-1, 1, -1]),
    Vertex([1, 1, -1]),
    Vertex([1, -1, -1]),
    Vertex([-1, -1, -1]),
    // right (1, 0, 0)
    Vertex([1, -1, -1]),
    Vertex([1, 1, -1]),
    Vertex([1, 1, 1]),
    Vertex([1, -1, 1]),
    // left (-1, 0, 0)
    Vertex([-1, -1, 1]),
    Vertex([-1, 1, 1]),
    Vertex([-1, 1, -1]),
    Vertex([-1, -1, -1]),
    // front (0, 1, 0)
    Vertex([1, 1, -1]),
    Vertex([-1, 1, -1]),
    Vertex([-1, 1, 1]),
    Vertex([1, 1, 1]),
    // back (0, -1, 0)
    Vertex([1, -1, 1]),
    Vertex([-1, -1, 1]),
    Vertex([-1, -1, -1]),
    Vertex([1, -1, -1]),
  ];
  ushort[] indices = [
    0, 1, 2, 2, 3, 0, // top
    4, 5, 6, 6, 7, 4, // bottom
    8, 9, 10, 10, 11, 8, // right
    12, 13, 14, 14, 15, 12, // left
    16, 17, 18, 18, 19, 16, // front
    20, 21, 22, 22, 23, 20, // back
  ];
  return Mesh(vertices, indices);
}

enum string cubeShader = `[[block]]
struct CameraUniform {
    view_proj: mat4x4<f32>;
};
[[group(0), binding(0)]]
var<uniform> camera: CameraUniform;

[[stage(vertex)]]
fn vs_main([[location(0)]] position: vec3<f32>) -> [[builtin(position)]] vec4<f32> {
  return camera.view_proj * vec4<f32>(position, 1.0);
}

[[stage(fragment)]]
fn fs_main() -> [[location(0)]] vec4<f32> {
    return vec4<f32>(0.5, 0.25, 1.0, 1.0);
}`;

extern (C) void wgpu_error_callback(ErrorType type, const char* message, void* userdata) {
  import std.string : fromStringz;
  writefln("WebGPU Error: %s: %s", type, message.fromStringz);
}

class Cube : Window {
  private const Mesh cube;
  private mat4f mvp;
  private Buffer vertexBuffer, indexBuffer, uniformBuffer;
  private BindGroup bindings;
  private RenderPipeline pipeline;

  this(string title) {
    super(title);
    this.cube = unitCube();
    const projection = mat4f.perspective(45f.rad, size.width / size.height, 1, 10);
    const view = mat4f.lookAt(vec3f(1.5, -5, 3), vec3f(0, 0, 0), vec3f(0, 0, 1));
    this.mvp = openGlToWgpuCorrection * projection * view;
  }

  override void initialize(const Device device) {
    static import wgpu.utils;
    assert(swapChain !is null);

    device.setUncapturedErrorCallback(&wgpu_error_callback);

    vertexBuffer = wgpu.utils.createBuffer(
      device, BufferUsage.vertex,
      cast(ubyte[]) cube.vertices.ptr[0..(Vertex.sizeof * cube.vertices.length)],
      "cube vertex buffer"
    );
    indexBuffer = wgpu.utils.createBuffer(
      device, BufferUsage.index,
      cast(ubyte[]) cube.indices.ptr[0..(ushort.sizeof * cube.indices.length)],
      "cube index buffer"
    );
    uniformBuffer = wgpu.utils.createBuffer(
      device, BufferUsage.uniform | BufferUsage.copyDst,
      cast(ubyte[]) mvp.ptr[0..(mat4f.sizeof)],
      "uniform buffer (camera)"
    );

    auto bindingLayout = device.createBindGroupLayout([
      uniformBuffer.bindingLayout(0, ShaderStage.vertex)
    ], "mvp projection matrix");
    bindings = device.createBindGroup(bindingLayout, [uniformBuffer.binding(0)], "camera");
    auto shader = device.createShaderModule(cubeShader);
    pipeline = device.createRenderPipeline(
      device.createPipelineLayout([bindingLayout]),
      VertexState(shader, "vs_main", [
        VertexBufferLayout(Vertex.sizeof, VertexStepMode.vertex, [VertexAttribute(VertexFormat.float32x3)])
      ]),
      PrimitiveState(PrimitiveTopology.triangleStrip, IndexFormat.uint16, FrontFace.ccw, CullMode.back),
      MultisampleState.singleSample,
      new FragmentState(
        shader, "fs_main", [new ColorTargetState(swapChain.format, BlendMode.alphaBlending.to!BlendState)]
      ),
    );
  }

  override void resizeRenderTarget(const Device device) {
    import wgpu.utils : resize;
    assert(device.ready && swapChain !is null);

    // Resize the swap chain and then destroy the old one
    auto extantSwapChain = swapChain;
    swapChain = swapChain.resize(device, size.width, size.height);
    extantSwapChain.destroy();

    // Adjust the camera's perspective
    const projection = mat4f.perspective(45f.rad, size.width / size.height, 1, 10);
    const view = mat4f.lookAt(vec3f(1.5, -5, 3), vec3f(0, 0, 0), vec3f(0, 0, 1));
    this.mvp = openGlToWgpuCorrection * projection * view;
    // TODO: Update the camera uniform buffer
  }

  override void render(const Device device) {
    import std.typecons : Yes;

    assert(swapChain !is null);
    auto swapChainTexture = swapChain.getNextTexture();

    // Render a cube
    auto encoder = device.createCommandEncoder();
    auto renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(swapChainTexture, /* Black */ Color(0, 0, 0, 1))
    );
    renderPass.setPipeline(pipeline);
    renderPass.setBindGroup(0, bindings);
    renderPass.setVertexBuffer(0, vertexBuffer);
    renderPass.setIndexBuffer!ushort(indexBuffer);
    renderPass.draw(cube.vertices.length.to!uint, 1);
    renderPass.end();

    auto commandBuffer = encoder.finish();
    device.queue.submit(commandBuffer);
    swapChain.present();

    // Force wait for a frame to render and pump callbacks
    device.poll(Yes.forceWait);
  }
}

void main() {
  const title = "Cube Example";
  title.writeln;

  auto window = new Cube(title);

  auto adapter = Instance.requestAdapter(window.surface, PowerPreference.lowPower);
  assert(adapter.ready, "Adapter instance was not initialized");
  writefln("Adapter properties: %s", adapter.properties);

  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready");
  writefln("Device limits: %s", device.limits);

  // The render pipeline renders data into this swap chain
  auto swapChainFormat = window.surface.preferredFormat(adapter);
  window.createSwapChain(device, swapChainFormat);

  window.runEventLoop(device);
  window.destroy();
}
