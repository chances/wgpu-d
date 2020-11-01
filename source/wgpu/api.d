/// An idiomatic D wrapper for wgpu-native.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.api;

import core.stdc.config : c_ulong;
import std.conv : to;
import std.string : toStringz;
import std.traits : fullyQualifiedName;

import wgpu.bindings;

/// Version of wgpu-native this library binds.
static const VERSION = "0.6.0";
/// Buffer-Texture copies must have bytes_per_row aligned to this number.
///
/// This doesn't apply to `Queue.writeTexture`.
static const COPY_BYTES_PER_ROW_ALIGNMENT = 256;

// TODO: Does the library need these?
/// Unknown
static const DESIRED_NUM_FRAMES = 3;
/// Maximum anisotropy.
static const MAX_ANISOTROPY = 16;
/// Maximum number of color targets.
static const MAX_COLOR_TARGETS = 4;
/// Maximum amount of mipmap levels.
static const MAX_MIP_LEVELS = 16;
/// Maximum number of vertex buffers.
static const MAX_VERTEX_BUFFERS = 16;

alias WgpuId = c_ulong;
alias RequestAdapterOptions = WGPURequestAdapterOptions;
alias AdapterInfo = WGPUCAdapterInfo;
alias Limits = WGPUCLimits;
alias Color = WGPUColor;
alias TextureDescriptor = WGPUTextureDescriptor;
alias TextureViewDescriptor = WGPUTextureViewDescriptor;
alias SamplerDescriptor = WGPUSamplerDescriptor;
alias SwapChainDescriptor = WGPUSwapChainDescriptor;
alias SwapChainOutput = WGPUSwapChainOutput;

alias BufferAddress = WGPUBufferAddress;
alias BufferDescriptor = WGPUBufferDescriptor;
alias CommandEncoderDescriptor = WGPUCommandEncoderDescriptor;
alias BindGroupDescriptor = WGPUBindGroupDescriptor;
alias BindGroupLayoutEntry = WGPUBindGroupLayoutEntry;
alias BindGroupLayoutDescriptor = WGPUBindGroupLayoutDescriptor;
alias PipelineLayoutDescriptor = WGPUPipelineLayoutDescriptor;
alias RenderPipelineDescriptor = WGPURenderPipelineDescriptor;
alias ComputePipelineDescriptor = WGPUComputePipelineDescriptor;
alias RenderPassDescriptor = WGPURenderPassDescriptor;
alias ComputePassDescriptor = WGPUComputePassDescriptor;
alias CommandBufferDescriptor = WGPUCommandBufferDescriptor;


/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.ShaderStage.html">wgpu::ShaderStage</a>
enum ShaderStage : WGPUShaderStage {
  none = 0,
  vertex = 1,
  fragment = 2,
  compute = 4
}

/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.BufferUsage.html">wgpu::BufferUsage</a>
enum BufferUsage : WGPUBufferUsage {
  mapRead = 1,
  mapWrite = 2,
  copySrc = 4,
  copyDst = 8,
  index = 16,
  vertex = 32,
  uniform = 64,
  storage = 128,
  indirect = 256
}

/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.TextureUsage.html">wgpu::TextureUsage</a>
enum TextureUsage : WGPUTextureUsage {
  copySrc = 1,
  copyDst = 2,
  sampled = 4,
  storage = 8,
  outputAttachment = 16
}

extern (C) private void wgpu_request_adapter_callback(ulong id, void* data) {
  assert(data !is null);
  auto adapter = cast(Adapter*) data;
  assert(id > 0);
  adapter.id = id;
}

/// A handle to a physical graphics and/or compute device.
///
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Adapter.html">wgpu::Adapter</a>
struct Adapter {
  package WgpuId id;

  /// Requests a new Adapter, asynchronously.
  ///
  /// Use `ready` to determine whether an Adapter was successfully requested.
  this(const RequestAdapterOptions options) {
    const allowedBackends = Backend.Vulkan | Backend.Metal | Backend.Dx12;
    wgpu_request_adapter_async(&options, allowedBackends, false, &wgpu_request_adapter_callback, &this);
  }

  ~this() {
    if (ready) wgpu_adapter_destroy(id);
  }

  /// Whether this Adapter handle has finished being requested and is ready for use.
  bool ready() @property const {
    return id > 0;
  }

  /// Information about this Adapter.
  AdapterInfo info() @property const {
    assert(ready);
    AdapterInfo info;
    wgpu_adapter_get_info(id, &info);
    return info;
  }

  /// Requests a connection to a physical device, creating a logical device.
  ///
  /// Params:
  /// limits =
  /// label = Optional label for this Device.
  Device requestDevice(const Limits limits, string label = fullyQualifiedName!Device) {
    assert(ready);
    auto id = wgpu_adapter_request_device(id, 0, &limits, true, toStringz(label));
    assert(id > 0);
    return Device(id, limits, label);
  }
}

/// An open connection to a graphics and/or compute device.
///
/// The `Device` is the responsible for the creation of most rendering and compute resources, as well as exposing `Queue` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Device.html">wgpu::Device</a>
struct Device {
  package WgpuId id;
  /// Limits on this Device
  Limits limits;
  /// label for this Device.
  string label;

  /// Obtains a queue which can accept `CommandBuffer` submissions.
  Queue queue() @property const {
    return Queue(wgpu_device_get_default_queue(id));
  }

  /// Creates a shader module from SPIR-V source code.
  ShaderModule createShaderModule(const ubyte[] spv) {
    import std.algorithm.iteration : map;
    import std.array : array;

    const bytes = spv.map!(byte_ => byte_.to!(const uint)).array;
    return ShaderModule(wgpu_device_create_shader_module(id, WGPUShaderSource(
      cast(const(uint)*) &bytes,
      spv.length
    )));
  }

  /// Creates an empty `CommandEncoder`.
  CommandEncoder createCommandEncoder(const CommandEncoderDescriptor descriptor) {
    return CommandEncoder(wgpu_device_create_command_encoder(id, &descriptor));
  }

  /// Creates a new bind group.
  BindGroup createBindGroup(const BindGroupDescriptor descriptor) {
    return BindGroup(wgpu_device_create_bind_group(id, &descriptor));
  }

  /// Creates a bind group layout.
  BindGroupLayout createBindGroupLayout(const BindGroupLayoutDescriptor descriptor) {
    return BindGroupLayout(wgpu_device_create_bind_group_layout(id, &descriptor));
  }

  /// Creates a bind group layout.
  PipelineLayout createPipelineLayout(const PipelineLayoutDescriptor descriptor) {
    return PipelineLayout(wgpu_device_create_pipeline_layout(id, &descriptor));
  }

  /// Creates a render pipeline.
  RenderPipeline createRenderPipeline(const RenderPipelineDescriptor descriptor) {
    return RenderPipeline(wgpu_device_create_render_pipeline(id, &descriptor));
  }

  /// Creates a compute pipeline.
  ComputePipeline createComputePipeline(const ComputePipelineDescriptor descriptor) {
    return ComputePipeline(wgpu_device_create_compute_pipeline(id, &descriptor));
  }

  /// Creates a new buffer.
  Buffer createBuffer(const BufferDescriptor descriptor) {
    return Buffer(wgpu_device_create_buffer(id, &descriptor));
  }

  /// Creates a new `Texture`.
  ///
  /// Params:
  /// descriptor = Specifies the general format of the texture.
  Texture createTexture(const TextureDescriptor descriptor) {
    return Texture(wgpu_device_create_texture(id, &descriptor));
  }

  /// Creates a new `Sampler`.
  ///
  /// Params:
  /// descriptor = Specifies the behavior of the sampler.
  Sampler createSampler(const SamplerDescriptor descriptor) {
    return Sampler(wgpu_device_create_sampler(id, &descriptor));
  }

  /// Create a new `SwapChain` which targets `surface`.
  SwapChain createSwapChain(const Surface surface, const SwapChainDescriptor descriptor) {
    return SwapChain(wgpu_device_create_swap_chain(id, surface.id, &descriptor));
  }
}

/// A handle to a presentable surface.
///
/// A Surface represents a platform-specific surface (e.g. a window) to which rendered images may be presented.
/// A Surface may be created with `Surface.create`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Surface.html">wgpu::Surface</a>
struct Surface {
  package WgpuId id;
}

/// A handle to a swap chain.
///
/// A `SwapChain` represents the image or series of images that will be presented to a `Surface`.
/// A `SwapChain` may be created with `Device.createSwapChain`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.SwapChain.html">wgpu::SwapChain</a>
struct SwapChain {
  package WgpuId id;

  SwapChainOutput getNextTexture() {
    return wgpu_swap_chain_get_next_texture(id);
  }
}

/// A handle to a GPU-accessible buffer.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Buffer.html">wgpu::Buffer</a>
struct Buffer {
  package WgpuId id;
}

/// A handle to a texture on the GPU.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Texture.html">wgpu::Texture</a>
struct Texture {
  package WgpuId id;

  /// Creates a view of this texture.
  TextureView createView(const TextureViewDescriptor descriptor) {
    return TextureView(wgpu_texture_create_view(id, &descriptor));
  }

  /// Creates a default view of this whole texture.
  TextureView createDefaultView() {
    return TextureView(wgpu_texture_create_view(id, null));
  }
}

/// A handle to a texture view.
///
/// A `TextureView` object describes a texture and associated metadata needed by a `RenderPipeline` or `BindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.TextureView.html">wgpu::TextureView</a>
struct TextureView {
  package WgpuId id;
}

/// A handle to a sampler.
///
/// A Sampler object defines how a pipeline will sample from a `TextureView`. Samplers define image
/// filters (including anisotropy) and address (wrapping) modes, among other things.
///
/// See the documentation for `SamplerDescriptor` for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Sampler.html">wgpu::Sampler</a>
struct Sampler {
  package WgpuId id;
}

/// A Queue executes finished C`ommandBuffer` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.Queue.html">wgpu::Queue</a>
struct Queue {
  package WgpuId id;

  /// Submits a series of finished command buffers for execution.
  void submit(CommandBuffer[] commands) {
    import std.algorithm.iteration : map;
    import std.array : array;

    auto commandIds = commands.map!(c => c.id).array;
    wgpu_queue_submit(id, cast(const(c_ulong)*) &commandIds, commands.length);
  }
}

/// An opaque handle to a command buffer on the GPU.
///
/// A `CommandBuffer` represents a complete sequence of commands that may be submitted to a command queue with `Queue.submit`.
/// A `CommandBuffer` is obtained by recording a series of commands to a `CommandEncoder` and then calling `CommandEncoder.finish`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.CommandBuffer.html">wgpu::CommandBuffer</a>
struct CommandBuffer {
  package WgpuId id;
}

/// A handle to a compiled shader module.
///
/// A `ShaderModule` represents a compiled shader module on the GPU. It can be created by passing valid SPIR-V source code to `Device.createShaderModule`.
/// Shader modules are used to define programmable stages of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.ShaderModule.html">wgpu::ShaderModule</a>
struct ShaderModule {
  package WgpuId id;
}

/// An object that encodes GPU operations.
///
/// A `CommandEncoder` can record `RenderPass`es, `ComputePass`es, and transfer operations between driver-managed resources like `Buffer`s and `Texture`s.
///
/// When finished recording, call `CommandEncoder.finish` to obtain a `CommandBuffer` which may be submitted for execution.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.CommandEncoder.html">wgpu::CommandEncoder</a>
struct CommandEncoder {
  package WgpuId id;
  /// Describes a `CommandBuffer`.
  const CommandBufferDescriptor descriptor;

  /// Finishes recording and returns a `CommandBuffer` that can be submitted for execution.
  CommandBuffer finish() {
    return CommandBuffer(wgpu_command_encoder_finish(id, &descriptor));
  }

  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  RenderPass beginRenderPass(const RenderPassDescriptor descriptor) {
    return RenderPass(wgpu_command_encoder_begin_render_pass(id, &descriptor));
  }

  /// Begins recording of a compute pass.
  ///
  /// This function returns a `ComputePass` object which records a single compute pass.
  ComputePass beginComputePass(const ComputePassDescriptor descriptor) {
    return ComputePass(wgpu_command_encoder_begin_compute_pass(id, &descriptor));
  }
}

/// An opaque handle to a binding group.
///
/// A `BindGroup` represents the set of resources bound to the bindings described by a `BindGroupLayout`.
/// It can be created with `Device.createBindGroup`. A `BindGroup` can be bound to a particular `RenderPass`
/// with `RenderPass.setBindGroup`, or to a `ComputePass` with `ComputePass.setBindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.BindGroup.html">wgpu::BindGroup</a>
struct BindGroup {
  package WgpuId id;
}

/// An opaque handle to a binding group layout.
///
/// A `BindGroupLayout` is a handle to the GPU-side layout of a binding group. It can be used to create
/// a `BindGroupDescriptor` object, which in turn can be used to create a `BindGroup` object with
/// `Device.createBindGroup`. A series of `BindGroupLayout`s can also be used to create a
/// `PipelineLayoutDescriptor`, which can be used to create a `PipelineLayout`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.BindGroupLayout.html">wgpu::BindGroupLayout</a>
struct BindGroupLayout {
  package WgpuId id;
}

/// An opaque handle to a pipeline layout.
///
/// A `PipelineLayout` object describes the available binding groups of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.PipelineLayout.html">wgpu::PipelineLayout</a>
struct PipelineLayout {
  package WgpuId id;
}

/// A handle to a rendering (graphics) pipeline.
///
/// A `RenderPipeline` object represents a graphics pipeline and its stages, bindings, vertex buffers and targets.
/// A `RenderPipeline` may be created with `Device.createRenderPipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.RenderPipeline.html">wgpu::RenderPipeline</a>
struct RenderPipeline {
  package WgpuId id;

  ~this() {
    wgpu_render_pipeline_destroy(id);
  }
}

/// An in-progress recording of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.RenderPass.html">wgpu::RenderPass</a>
struct RenderPass {
  import std.typecons : Tuple;

  package WGPURenderPass* instance;

  /// Sets the active bind group for a given bind group index.
  void setBindGroup(const uint index, const BindGroup bindGroup, BufferAddress[] offsets) {
    wgpu_render_pass_set_bind_group(instance, index, bindGroup.id, &offsets, offsets.length);
  }

  /// Sets the active render pipeline.
  ///
  /// Subsequent draw calls will exhibit the behavior defined by `pipeline`.
  void setPipeline(const RenderPipeline pipeline) {
    wgpu_render_pass_set_pipeline(instance, pipeline.id);
  }

  void setBlendColor(const Color color) {
    wgpu_render_pass_set_blend_color(instance, &color);
  }

  /// Sets the active index buffer.
  ///
  /// Subsequent calls to `drawIndexed` on this `RenderPass` will use buffer as the source index buffer.
  void setIndexBuffer(const Buffer buffer, const BufferAddress offset) {
    wgpu_render_pass_set_index_buffer(instance, buffer.id, offset, buffer.size);
  }

  /// Sets the active vertex buffers, starting from `startSlot`.
  ///
  /// Each element of `bufferPairs` describes a vertex buffer and an offset in bytes into that buffer.
  /// The offset must be aligned to a multiple of 4 bytes.
  void setVertexBuffers(uint startSlot, Tuple!(Buffer, BufferAddress) bufferPairs) {
    foreach (buffer, bufferAddress; bufferPairs)
      wgpu_render_pass_set_vertex_buffer(instance, startSlot, buffer.id, bufferAddress, buffer.size);
  }

  /// Sets the scissor region.
  ///
  /// Subsequent draw calls will discard any fragments that fall outside this region.
  void setScissorRect(uint x, uint y, uint w, uint h) {
    wgpu_render_pass_set_scissor_rect(instance, x, y, w, h);
  }

  /// Sets the viewport region.
  ///
  /// Subsequent draw calls will draw any fragments in this region.
  void setViewport(float x, float y, float w, float h, float minDepth, float maxDepth) {
    wgpu_render_pass_set_viewport(instance, x, y, w, h, minDepth, maxDepth);
  }

  /// Sets the stencil reference.
  ///
  /// Subsequent stencil tests will test against this value.
  void setStencilReference(uint reference) {
    wgpu_render_pass_set_stencil_reference(instance, reference);
  }

  /// Draws primitives from the active vertex buffer(s).
  ///
  /// The active vertex buffers can be set with `RenderPass.setVertexBuffers`.
  void draw(uint[] vertices, uint[] instances) {
    assert(vertices.length);
    assert(instances.length);
  }

  /// Draws indexed primitives using the active index buffer and the active vertex buffers.
  ///
  /// The active index buffer can be set with `RenderPass.setIndexBuffer`, while the active vertex
  /// buffers can be set with `RenderPass.setVertexBuffers`.
  void drawIndexed(uint[] indices, int baseVertex, uint[] instances) {
    assert(indices.length);
    assert(baseVertex >= 0);
    assert(instances.length);
  }
}

/// A handle to a compute pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.ComputePipeline.html">wgpu::ComputePipeline</a>
struct ComputePipeline {
  package WgpuId id;
}

/// An in-progress recording of a compute pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.3.0/wgpu/struct.ComputePass.html">wgpu::ComputePass</a>
struct ComputePass {
  package WGPUComputePass* instance;

  /// Sets the active bind group for a given bind group index.
  void setBindGroup(const uint index, const BindGroup bindGroup, BufferAddress[] offsets) {
    wgpu_compute_pass_set_bind_group(instance, index, bindGroup.id, &offsets, offsets.length);
  }

  /// Sets the active compute pipeline.
  void setPipeline(const ComputePipeline pipeline) {
    wgpu_compute_pass_set_pipeline(instance, pipeline.id);
  }

  ///Dispatches compute work operations.
  ///
  /// x, y and z denote the number of work groups to dispatch in each dimension.
  void dispatch(const uint x, const uint y, const uint z) {
    wgpu_compute_pass_dispatch(instance, x, y, z);
  }
}
