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

enum string cubeShader = `struct CameraUniform {
  view_proj: mat4x4f,
};
@group(0) @binding(0)
var<uniform> camera: CameraUniform;

@vertex
fn vs_main(@location(0) position: vec3f) -> @builtin(position) vec4f {
  return camera.view_proj * vec4f(position, 1.0);
}

@fragment
fn fs_main() -> @location(0) vec4f {
  return vec4f(0.5, 0.25, 1.0, 1.0);
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
    import std.process : environment;
    static import wgpu.utils;

    // Enable stack traces from Rust-land
    debug environment["RUST_BACKTRACE"] = "1";

    auto swapChainFormat = this.surface.preferredFormat(device.adapter);

    device.setUncapturedErrorCallback(&wgpu_error_callback);

    "Creating geometry buffers...".writeln;
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
      new FragmentState(shader, "fs_main", [
        new ColorTargetState(swapChainFormat, BlendMode.alphaBlending.to!BlendState)
      ]),
    );
  }

  override void resizeRenderTarget(const Device device, const int width, const int height) {
    import wgpu.utils : resize;
    assert(device.ready);
    if (width == 0 && height == 0) return;

    this.surface.resize(width, height);

    // Adjust the camera's perspective
    const projection = mat4f.perspective(45f.rad, size.width / size.height, 1, 10);
    const view = mat4f.lookAt(vec3f(1.5, -5, 3), vec3f(0, 0, 0), vec3f(0, 0, 1));
    this.mvp = openGlToWgpuCorrection * projection * view;
    // TODO: Update the camera uniform buffer
  }

  override void render(const Device device) {
    import wgpu.utils : wrap;
    import std.conv : text;
    import std.typecons : Yes;

    auto swapChain = this.surface.getCurrentTexture();
    // TODO: Validate the texture descriptor is correct
    auto swapChainTexture = swapChain.texture.wrap(this.surface.descriptor);
    final switch (swapChain.status) {
      case SurfaceTextureStatus.success:
        // All good, could check for `swapChain.suboptimal` here.
        break;
      case SurfaceTextureStatus.outOfMemory:
        throw new Error("GPU device is out of memory!");
      case SurfaceTextureStatus.deviceLost:
        throw new Error("GPU device was lost!");
      case SurfaceTextureStatus.force32:
        throw new Error("Could not get swap chain texture: " ~ swapChain.status.text);
      case SurfaceTextureStatus.timeout:
      case SurfaceTextureStatus.outdated:
      case SurfaceTextureStatus.lost:
        // Skip this frame, and re-configure surface.
        if (swapChain.texture !is null) swapChainTexture.destroy();
        auto size = this.size;
        this.resizeRenderTarget(device, size.width, size.height);
        return;
    }

    // Render a cube
    auto encoder = device.createCommandEncoder();
    auto renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(swapChainTexture.defaultView, /* Black */ Color(0, 0, 0, 1))
    );
    renderPass.setPipeline(pipeline);
    renderPass.setBindGroup(0, bindings);
    renderPass.setVertexBuffer(0, vertexBuffer);
    renderPass.setIndexBuffer!ushort(indexBuffer);
    renderPass.draw(cube.vertices.length.to!uint, 1);
    renderPass.end();

    auto commandBuffer = encoder.finish();
    device.queue.submit(commandBuffer);
    surface.present();

    // Force wait for a frame to render and pump callbacks
    device.poll(Yes.forceWait);
  }
}

void main() {
  const title = "Cube Example";
  title.writeln;
  auto window = new Cube(title);

  "Requesting GPU adapter...".writeln;
  auto adapter = window.gpu.requestAdapter(window.surface, PowerPreference.lowPower);
  assert(adapter.ready, "Adapter instance was not initialized");
  writefln("Adapter properties: %s", adapter.properties);

  "Requesting GPU adapter device...".writeln;
  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready");
  writefln("Device limits: %s", device.limits);

  window.runEventLoop(device);
  window.destroy();
}
