/// An idiomatic D wrapper for <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a>.
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

/// Version of <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a> this library binds.
/// See_Also: <a href="https://github.com/gfx-rs/wgpu-native/releases/tag/v0.6.0">github.com/gfx-rs/wgpu-native/releases/tag/v0.6.0</a>
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
/// Metadata about a backend adapter.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.AdapterInfo.html">wgpu::AdapterInfo</a>
alias AdapterInfo = WGPUCAdapterInfo;
/// Features that are not guaranteed to be supported.
///
/// These are either part of the webgpu standard, or are extension features supported by wgpu when targeting native.
///
/// If you want to use a feature, you need to first verify that the adapter supports the feature. If the adapter
/// does not support the feature, requesting a device with it enabled will panic.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Features.html">wgpu::Features</a>
alias Features = WGPUFeatures;
/// Represents the sets of limits an adapter/device supports.
///
/// Limits "better" than the default must be supported by the adapter and requested when requesting a device.
/// If limits "better" than the adapter supports are requested, requesting a device will panic. Once a device is
/// requested, you may only use resources up to the limits requested even if the adapter supports "better" limits.
///
/// Requesting limits that are "better" than you need may cause performance to decrease because the implementation
/// needs to support more than is needed. You should ideally only request exactly what you need.
///
/// <strong>See Also</strong>: https://gpuweb.github.io/gpuweb/#dictdef-gpulimits
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Limits.html">wgpu::Limits</a>
alias Limits = WGPUCLimits;
/// RGBA double precision color.
///
/// This is not to be used as a generic color type, only for specific wgpu interfaces.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Color.html">wgpu::Color</a>
alias Color = WGPUColor;
/// Describes a `Texture`.
alias TextureDescriptor = WGPUTextureDescriptor;
/// Describes a `TextureView`.
alias TextureViewDescriptor = WGPUTextureViewDescriptor;
/// Describes a `Sampler`.
alias SamplerDescriptor = WGPUSamplerDescriptor;
/// Extent of a texture related operation.
alias Extent3d = WGPUExtent3d;
/// Describes a `SwapChain`.
alias SwapChainDescriptor = WGPUSwapChainDescriptor;

/// Integral type used for buffer offsets.
alias BufferAddress = WGPUBufferAddress;
/// Describes a `Buffer`.
alias BufferDescriptor = WGPUBufferDescriptor;
/// Describes a `CommandEncoder`.
alias CommandEncoderDescriptor = WGPUCommandEncoderDescriptor;
/// Origin of a copy to/from a texture.
alias Origin3d = WGPUOrigin3d;
/// View of a texture which can be used to copy to/from a buffer/texture.
alias TextureCopyView = WGPUTextureCopyView;
/// Layout of a texture in a buffer's memory.
alias TextureDataLayout = WGPUTextureDataLayout;
/// View of a buffer which can be used to copy to/from a texture.
alias BufferCopyView = WGPUBufferCopyView;
/// Describes a `BindGroup`.
alias BindGroupDescriptor = WGPUBindGroupDescriptor;
/// Describes a single binding inside a bind group.
alias BindGroupLayoutEntry = WGPUBindGroupLayoutEntry;
/// Describes a `BindGroupLayout`.
alias BindGroupLayoutDescriptor = WGPUBindGroupLayoutDescriptor;
/// Describes a `PipelineLayout`.
alias PipelineLayoutDescriptor = WGPUPipelineLayoutDescriptor;
/// Describes a `RenderPipeline`.
alias RenderPipelineDescriptor = WGPURenderPipelineDescriptor;
/// Describes a `ComputePipeline`.
alias ComputePipelineDescriptor = WGPUComputePipelineDescriptor;
/// Describes a `RenderPass`.
alias RenderPassDescriptor = WGPURenderPassDescriptor;
/// Describes a color attachment to a `RenderPass`.
alias RenderPassColorAttachmentDescriptor = WGPURenderPassColorAttachmentDescriptor;
alias PassChannel_Color = WGPUPassChannel_Color;
/// Describes a `ComputePass`.
alias ComputePassDescriptor = WGPUComputePassDescriptor;
/// Describes a `CommandBuffer`.
alias CommandBufferDescriptor = WGPUCommandBufferDescriptor;

public import wgpu.bindings: AddressMode, Backend, BindingType, BlendFactor, BlendOperation, CDeviceType,
  CompareFunction, CullMode, FilterMode, FrontFace, IndexFormat, InputStepMode, LoadOp, LogLevel, PowerPreference,
  PresentMode, PrimitiveTopology, SType, StencilOperation, StoreOp, SwapChainStatus, TextureAspect,
  TextureComponentType, TextureDimension, TextureFormat, TextureViewDimension, VertexFormat;

/// Describes the shader stages that a binding will be visible from.
///
/// These can be combined in a bitwise combination.
///
/// For example, something that is visible from both vertex and fragment shaders can be defined as:
///
/// `ShaderStage.vertex | ShaderStage.fragment`
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ShaderStage.html">wgpu::ShaderStage</a>
enum ShaderStage : WGPUShaderStage {
  /// Binding is not visible from any shader stage.
  none = 0,
  /// Binding is visible from the vertex shader of a render pipeline.
  vertex = 1,
  /// Binding is visible from the fragment shader of a render pipeline.
  fragment = 2,
  /// Binding is visible from the compute shader of a compute pipeline.
  compute = 4
}

/// Different ways that you can use a buffer.
///
/// The usages determine what kind of memory the buffer is allocated from and what actions the buffer can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.BufferUsage.html">wgpu::BufferUsage</a>
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

/// Different ways that you can use a texture.
///
/// The usages determine what kind of memory the texture is allocated from and what actions the texture can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.TextureUsage.html">wgpu::TextureUsage</a>
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
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Adapter.html">wgpu::Adapter</a>
struct Adapter {
  /// Handle identifier.
  WgpuId id;

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

  /// List all features that are supported with this adapter.
  ///
  /// Features must be explicitly requested in `Adapter.requestDevice` in order to use them.
  Features features() @property const {
    return wgpu_adapter_features(id);
  }

  /// List the "best" limits that are supported by this adapter.
  ///
  /// Limits must be explicitly requested in `Adapter.requestDevice` to set the values that you are allowed to use.
  Limits limits() @property const {
    return wgpu_adapter_limits(id);
  }

  /// Requests a connection to a physical device, creating a logical device.
  ///
  /// Params:
  /// limits = The sets of limits the device supports.
  /// label = Optional label for the `Device`.
  Device requestDevice(const Limits limits, string label = fullyQualifiedName!Device) {
    assert(ready);
    auto id = wgpu_adapter_request_device(id, 0, &limits, true, toStringz(label));
    return Device(id, label);
  }
}

/// An open connection to a graphics and/or compute device.
///
/// The `Device` is the responsible for the creation of most rendering and compute resources, as well as exposing `Queue` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Device.html">wgpu::Device</a>
struct Device {
  /// Handle identifier.
  WgpuId id;
  /// Label for this Device.
  string label;

  ~this() {
    if (ready) wgpu_device_destroy(id);
  }

  /// Whether this Device handle is valid and ready for use.
  ///
  /// If `false`, `Adapter.requestDevice` likely failed.
  bool ready() @property const {
    return id > 0;
  }

  /// List all limits that were requested of this device.
  ///
  /// If any of these limits are exceeded, functions may panic.
  Limits limits() @property const {
    return wgpu_device_limits(id);
  }

  /// Obtains a queue which can accept `CommandBuffer` submissions.
  Queue queue() @property const {
    return Queue(wgpu_device_get_default_queue(id));
  }

  /// Check for resource cleanups and mapping callbacks.
  /// Params:
  /// forceWait = Whether or not the call should block.
  void poll(bool forceWait = false) {
    wgpu_device_poll(id, forceWait);
  }

  /// Creates a shader module from SPIR-V source code.
  ShaderModule createShaderModule(const byte[] spv) {
    import std.algorithm.iteration : map;
    import std.array : array;

    const bytes = spv.map!(byte_ => byte_.to!(const uint)).array;
    return ShaderModule(wgpu_device_create_shader_module(
      id,
      WGPUShaderSource(bytes.ptr, spv.length))
    );
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
    return Buffer(wgpu_device_create_buffer(id, &descriptor), descriptor);
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
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Surface.html">wgpu::Surface</a>
struct Surface {
  /// Handle identifier.
  WgpuId id;

  version (Windows) {
    /// Create a new `Surface` from an Android handle.
    static Surface fromAndroid(void* androidNativeWindow) {
      return Surface(wgpu_create_surface_from_android( androidNativeWindow));
    }
  }
  version (OSX) {
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(void* layer) {
      return Surface(wgpu_create_surface_from_metal_layer(layer));
    }
  }
  version (Linux) {
    /// Create a new `Surface` from a Wayland window handle.
    static Surface fromWayland(void* surface, void* display) {
      return Surface(wgpu_create_surface_from_wayland(surface, display));
    }
  }
  version (Windows) {
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(void* _hinstance, void* hwnd) {
      return Surface(wgpu_create_surface_from_windows_hwnd(_hinstance, hwnd));
    }
  }
  version (Linux) {
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(const(void)** display, c_ulong window) {
      return Surface(wgpu_create_surface_from_xlib(display, window));
    }
  }
}

/// A handle to a swap chain.
///
/// A `SwapChain` represents the image or series of images that will be presented to a `Surface`.
/// A `SwapChain` may be created with `Device.createSwapChain`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.SwapChain.html">wgpu::SwapChain</a>
struct SwapChain {
  /// Handle identifier.
  WgpuId id;

  /// Returns the next texture to be presented by the swapchain for drawing.
  SwapChainOutput getNextTexture() {
    auto output = wgpu_swap_chain_get_next_texture(id);
    auto status = output.status.to!int.to!SwapChainStatus;
    auto successful = status == SwapChainStatus.Good || status == SwapChainStatus.Suboptimal;
    TextureView* view = null;
    if (successful) view = new TextureView(output.view_id);

    return SwapChainOutput(
      view,
      successful,
      status == SwapChainStatus.Suboptimal,
      output.status.to!int > 1 ? output.status.to!int.to!SwapChainError : SwapChainError.None
    );
  }
}

/// Result of an unsuccessful call to `SwapChain.getNextTexture`.
enum SwapChainError {
  None = 0,
  /// A timeout was encountered while trying to acquire the next frame.
  Timeout = 2,
  /// The underlying surface has changed, and therefore the swap chain must be updated.
  Outdated = 3,
  /// The swap chain has been lost and needs to be recreated.
  Lost = 4,
  /// There is no more memory left to allocate a new frame.
  OutOfMemory = 5,
}

/// Result of a call to `SwapChain.getNextTexture`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.SwapChainFrame.html">wgpu::SwapChainFrame</a>
const struct SwapChainOutput {
  /// The texture into which the next frame should be rendered. `null` if the call to `SwapChain.getNextTexture` was unsuccessful.
  TextureView* view;
  /// Whether a call to `SwapChain.getNextTexture` was successful.
  bool success = false;
  /// `true` if the acquired buffer can still be used for rendering, but should be recreated for maximum performance.
  bool suboptimal = false;
  /// Result of an unsuccessful call to `SwapChain.getNextTexture`. `SwapChainError.None` if the call was successful.
  SwapChainError error = SwapChainError.None;
}

/// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
enum BufferMapAsyncStatus {
  success = 0,
  error = 1,
  unknown = 2,
  contextLost = 3
}

extern (C) private void wgpu_buffer_map_callback(WGPUBufferMapAsyncStatus status, ubyte* data) {
  assert(data !is null);
  auto buffer = cast(Buffer*) data;
  assert(buffer.id);

  buffer.status = status.to!int.to!BufferMapAsyncStatus;
}

/// A handle to a GPU-accessible buffer.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Buffer.html">wgpu::Buffer</a>
struct Buffer {
  /// Handle identifier.
  WgpuId id;
  /// Describes a `Buffer`.
  BufferDescriptor descriptor;
  /// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  BufferMapAsyncStatus status = BufferMapAsyncStatus.unknown;

  ~this() {
    wgpu_buffer_destroy(id);
  }

  /// Get the sliced `Buffer` data requested by either `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  ubyte[] getMappedRange(BufferAddress start, BufferAddress size) {
    assert(status == BufferMapAsyncStatus.success);

    auto data = wgpu_buffer_get_mapped_range(id, start, size);
    return data[0 .. size];
  }

  /// Map the buffer for reading asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapReadAsync(BufferAddress start, BufferAddress size) {
    wgpu_buffer_map_read_async(id, start, size, &wgpu_buffer_map_callback, cast(ubyte*) &this);
  }

  /// Map the buffer for writing asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapWriteAsync(BufferAddress start, BufferAddress size) {
    wgpu_buffer_map_write_async(id, start, size, &wgpu_buffer_map_callback, cast(ubyte*) &this);
  }

  /// Flushes any pending write operations and unmaps the buffer from host memory.
  void unmap() {
    wgpu_buffer_unmap(id);
  }
}

/// A handle to a texture on the GPU.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Texture.html">wgpu::Texture</a>
struct Texture {
  /// Handle identifier.
  WgpuId id;

  ~this() {
    wgpu_texture_destroy(id);
  }

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
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.TextureView.html">wgpu::TextureView</a>
struct TextureView {
  /// Handle identifier.
  WgpuId id;
}

/// A handle to a sampler.
///
/// A Sampler object defines how a pipeline will sample from a `TextureView`. Samplers define image
/// filters (including anisotropy) and address (wrapping) modes, among other things.
///
/// See the documentation for `SamplerDescriptor` for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Sampler.html">wgpu::Sampler</a>
struct Sampler {
  /// Handle identifier.
  WgpuId id;
}

/// A Queue executes finished C`ommandBuffer` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Queue.html">wgpu::Queue</a>
struct Queue {
  /// Handle identifier.
  WgpuId id;

  /// Submits a finished command buffer for execution.
  void submit(CommandBuffer commands) {
    submit([commands]);
  }
  /// Submits a series of finished command buffers for execution.
  void submit(CommandBuffer[] commandBuffers) {
    import std.algorithm.iteration : map;
    import std.array : array;

    const commandBufferIds = commandBuffers.map!(c => c.id).array;
    wgpu_queue_submit(id, commandBufferIds.ptr, commandBuffers.length);
  }
}

/// An opaque handle to a command buffer on the GPU.
///
/// A `CommandBuffer` represents a complete sequence of commands that may be submitted to a command queue with `Queue.submit`.
/// A `CommandBuffer` is obtained by recording a series of commands to a `CommandEncoder` and then calling `CommandEncoder.finish`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.CommandBuffer.html">wgpu::CommandBuffer</a>
struct CommandBuffer {
  /// Handle identifier.
  WgpuId id;
}

/// A handle to a compiled shader module.
///
/// A `ShaderModule` represents a compiled shader module on the GPU. It can be created by passing valid SPIR-V source code to `Device.createShaderModule`.
/// Shader modules are used to define programmable stages of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ShaderModule.html">wgpu::ShaderModule</a>
struct ShaderModule {
  /// Handle identifier.
  WgpuId id;
}

/// An object that encodes GPU operations.
///
/// A `CommandEncoder` can record `RenderPass`es, `ComputePass`es, and transfer operations between driver-managed resources like `Buffer`s and `Texture`s.
///
/// When finished recording, call `CommandEncoder.finish` to obtain a `CommandBuffer` which may be submitted for execution.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.CommandEncoder.html">wgpu::CommandEncoder</a>
struct CommandEncoder {
  /// Handle identifier.
  WgpuId id;
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

  /// Copy data from a texture to a buffer.
  void copyTextureToBuffer(const TextureCopyView source, const BufferCopyView destination, const Extent3d copySize) {
    wgpu_command_encoder_copy_texture_to_buffer(id, &source, &destination, &copySize);
  }
}

/// An opaque handle to a binding group.
///
/// A `BindGroup` represents the set of resources bound to the bindings described by a `BindGroupLayout`.
/// It can be created with `Device.createBindGroup`. A `BindGroup` can be bound to a particular `RenderPass`
/// with `RenderPass.setBindGroup`, or to a `ComputePass` with `ComputePass.setBindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.BindGroup.html">wgpu::BindGroup</a>
struct BindGroup {
  /// Handle identifier.
  WgpuId id;
}

/// An opaque handle to a binding group layout.
///
/// A `BindGroupLayout` is a handle to the GPU-side layout of a binding group. It can be used to create
/// a `BindGroupDescriptor` object, which in turn can be used to create a `BindGroup` object with
/// `Device.createBindGroup`. A series of `BindGroupLayout`s can also be used to create a
/// `PipelineLayoutDescriptor`, which can be used to create a `PipelineLayout`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.BindGroupLayout.html">wgpu::BindGroupLayout</a>
struct BindGroupLayout {
  /// Handle identifier.
  WgpuId id;
}

/// An opaque handle to a pipeline layout.
///
/// A `PipelineLayout` object describes the available binding groups of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.PipelineLayout.html">wgpu::PipelineLayout</a>
struct PipelineLayout {
  /// Handle identifier.
  WgpuId id;
}

/// A handle to a rendering (graphics) pipeline.
///
/// A `RenderPipeline` object represents a graphics pipeline and its stages, bindings, vertex buffers and targets.
/// A `RenderPipeline` may be created with `Device.createRenderPipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPipeline.html">wgpu::RenderPipeline</a>
struct RenderPipeline {
  /// Handle identifier.
  WgpuId id;

  ~this() {
    wgpu_render_pipeline_destroy(id);
  }
}

/// An in-progress recording of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPass.html">wgpu::RenderPass</a>
struct RenderPass {
  import std.typecons : Tuple;

  package WGPURenderPass* instance;

  /// Sets the active bind group for a given bind group index.
  void setBindGroup(const uint index, const BindGroup bindGroup, BufferAddress[] offsets) {
    import std.algorithm.iteration : map;
    import std.array : array;

    auto offsetsAsUints = offsets.map!(offset => offset.to!(const uint)).array;
    wgpu_render_pass_set_bind_group(instance, index, bindGroup.id, offsetsAsUints.ptr, offsets.length);
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
    wgpu_render_pass_set_index_buffer(instance, buffer.id, offset, buffer.descriptor.size);
  }

  /// Sets the active vertex buffers, starting from `startSlot`.
  ///
  /// Each element of `bufferPairs` describes a vertex buffer and an offset in bytes into that buffer.
  /// The offset must be aligned to a multiple of 4 bytes.
  void setVertexBuffers(uint startSlot, Tuple!(Buffer, BufferAddress)[] bufferPairs) {
    foreach (bufferPair; bufferPairs) {
      auto buffer = bufferPair[0];
      auto bufferAddress = bufferPair[1];
      wgpu_render_pass_set_vertex_buffer(instance, startSlot, buffer.id, bufferAddress, buffer.descriptor.size);
    }
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
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ComputePipeline.html">wgpu::ComputePipeline</a>
struct ComputePipeline {
  /// Handle identifier.
  WgpuId id;
}

/// An in-progress recording of a compute pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ComputePass.html">wgpu::ComputePass</a>
struct ComputePass {
  package WGPUComputePass* instance;

  /// Sets the active bind group for a given bind group index.
  void setBindGroup(const uint index, const BindGroup bindGroup, BufferAddress[] offsets) {
    import std.algorithm.iteration : map;
    import std.array : array;

    auto offsetsAsUints = offsets.map!(offset => offset.to!(const uint)).array;
    wgpu_compute_pass_set_bind_group(instance, index, bindGroup.id, offsetsAsUints.ptr, offsets.length);
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
