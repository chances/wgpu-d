import std.conv : to;
import std.math : floor;
import std.stdio;

import bindbc.glfw;
import wgpu.api;

package:

enum string triangleShader = `@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> @builtin(position) vec4f {
  let x = f32(i32(in_vertex_index) - 1);
  let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
  return vec4f(x, y, 0.0, 1.0);
}

@fragment
fn fs_main() -> @location(0) vec4f {
  return vec4f(1.0, 0.0, 0.0, 1.0);
}`;
enum string fullScreenQuadShader = `struct VertexOutput {
  @builtin(position) clip_position: vec4f;
  @location(0) tex_coords: vec2f;
};

@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> VertexOutput {
  let x = f32(i32(in_vertex_index) - 1);
  let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
  return VertexOutput(vec4f(x, y, 0.0, 1.0), vec2f(x, y));
}

@group(0) @binding(0)
var diffuse: texture_2d<f32>;
@group(0) @binding(1)
var diffuseSampler: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
  return textureSample(diffuse, diffuseSampler, in.tex_coords);
}`;

import examples.window : Window;

class Triangle : Window {
  package Instance instance;
  private Texture texture;
  private Pipeline pipeline;
  private Buffer outputBuffer;
  private auto captureFrame = false;

  this() {
    // Create window and WebGPU resources
    this.instance = Instance.create();
    assert(instance.id, "Could not create WebGPU instance.");

    // TODO: auto controls = "Press ESC to quit, P to capture framebuffer";
    auto title = "Triangle Example";
    title.writeln;

    const width = 640;
    const height = 480;
    super(title, width, height, instance);
  }
  ~this() {
    pipeline.destroy();
    outputBuffer.destroy();
    texture.destroy();
  }

  override void initialize(const Device device) {
    import std.process : environment;
    import wgpu.utils : valid;
    assert(device.valid);

    // Enable stack traces from Rust-land
    debug environment["RUST_BACKTRACE"] = "1";

    auto swapChainFormat = this.surface.preferredFormat(device.adapter);

    // The render pipeline renders data into this texture
    this.texture = device.createTexture(
      size.width, size.height,
      swapChainFormat,
      TextureUsage.renderAttachment | TextureUsage.copySrc | TextureUsage.textureBinding,
    );

    auto shader = device.createShaderModule(triangleShader);
    this.pipeline = device.createRenderPipeline(
      device.emptyPipelineLayout,
      VertexState(shader, "vs_main"),
      PrimitiveState(PrimitiveTopology.triangleList, IndexFormat.undefined, FrontFace.ccw, CullMode.none),
      texture.multisampleState,
      new FragmentState(shader, "fs_main", [
        texture.asRenderTarget(BlendMode.replace)
      ]),
    );
    assert(pipeline.to!RenderPipeline.valid, "Render pipeline is invalid");

    // The output buffer lets us retrieve data as an array
    this.outputBuffer = device.createBuffer(
      BufferUsage.mapRead | BufferUsage.copyDst,
      texture.paddedBytesPerRow * texture.height
    );
  }

  override void resizeRenderTarget(const Device device, const int width, const int height) {
    import wgpu.utils : resize;
    assert(device.ready);
    if (width == 0 && height == 0) return;

    this.surface.resize(width, height);
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

    // Render a triangle
    auto encoder = device.createCommandEncoder();
    auto renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(
        swapChainTexture.defaultView, /* Transparent Black */ Color(0, 0, 0, 0)
      )
    );
    renderPass.setPipeline(pipeline.to!RenderPipeline);
    renderPass.draw(3, 1);
    renderPass.end();

    // Copy the data from the texture to the buffer
    if (captureFrame) encoder.copyTextureToBuffer(texture, outputBuffer);

    // Blit to swap chain
    renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(swapChainTexture.defaultView, /* Black */ Color(0, 0, 0, 1))
    );
    renderPass.setPipeline(pipeline.to!RenderPipeline);
    renderPass.draw(3, 1);
    renderPass.end();

    auto commandBuffer = encoder.finish();
    device.queue.submit(commandBuffer);
    this.surface.present();

    // Request a slice of the output buffer
    if (captureFrame) outputBuffer.mapReadAsync(0, outputBuffer.descriptor.size);

    // Force wait for a frame to render and pump callbacks
    device.poll(Yes.forceWait);

    if (!captureFrame) return;

    auto paddedBuffer = outputBuffer.getMappedRange(0, outputBuffer.descriptor.size);

    import std.algorithm.iteration : map, joiner;
    import std.array : array;
    import std.range : chunks;
    auto data = paddedBuffer.chunks(texture.paddedBytesPerRow)
      .map!(paddedRow => paddedRow[0 .. texture.bytesPerRow]).joiner.array;

    // TODO: Switch to https://code.dlang.org/packages/imagefmt
    import imageformats : ColFmt, write_image;
    write_image("bin/triangle.png", size.width, size.height, data, ColFmt.RGBA);
    captureFrame = false;

    outputBuffer.unmap();
  }
}

// Adapted from https://github.com/gfx-rs/wgpu-native/blob/v0.10.4.1/examples/triangle/main.c
// See also https://sotrh.github.io/learn-wgpu/beginner/tutorial5-textures
public void main() {
  import std.exception : enforce;
  import std.functional : toDelegate;
  import std.string : toStringz;
  import std.typecons : Yes;
  import wgpu.utils : valid;

  auto app = new Triangle();

  auto adapter = app.instance.requestAdapter(app.surface, PowerPreference.lowPower);
  assert(adapter.ready, "Adapter instance was not initialized");

  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready");

  app.runEventLoop(device);
  app.destroy();
}
