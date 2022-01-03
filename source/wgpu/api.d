/// An idiomatic D wrapper for <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a>.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020-2022 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.api;

import core.stdc.config : c_ulong;
import std.conv : to;
import std.string : toStringz;
import std.traits : fullyQualifiedName;

import wgpu.bindings;
public import wgpu.limits;

/// Version of <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a> this library binds.
/// See_Also: <a href="https://github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1">github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1</a>
static const VERSION = "0.10.4.1";

/// Bound uniform/storage buffer offsets must be aligned to this number.
static const uint BIND_BUFFER_ALIGNMENT = 256;

/// Buffer-Texture copies must have `TextureDataLayout.bytesPerRow` aligned to this number.
///
/// This doesn't apply to `Queue.writeTexture`.
static const COPY_BYTES_PER_ROW_ALIGNMENT = 256;

// TODO: Does the library need these?
/// Maximum anisotropy.
static const MAX_ANISOTROPY = 16;
/// Maximum number of color targets.
static const MAX_COLOR_TARGETS = 4;
/// Maximum amount of mipmap levels.
static const MAX_MIP_LEVELS = 16;
/// Maximum number of vertex buffers.
static const MAX_VERTEX_BUFFERS = 16;

// Opaque Pointers
// TODO: Implement a wrapper around `WGPUQuerySet`
alias QuerySet = WGPUQuerySet;

// Structures
alias ChainedStruct = WGPUChainedStruct;
alias ChainedStructOut = WGPUChainedStructOut;
alias AdapterProperties = WGPUAdapterProperties;
alias BindGroupEntry = WGPUBindGroupEntry;
alias BlendComponent = WGPUBlendComponent;
alias BufferBindingLayout = WGPUBufferBindingLayout;
/// Describes a `Buffer`.
alias BufferDescriptor = WGPUBufferDescriptor;
/// RGBA double precision color.
///
/// This is not to be used as a generic color type, only for specific wgpu interfaces.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Color.html">wgpu::Color</a>
alias Color = WGPUColor;
/// Describes a `CommandBuffer`.
alias CommandBufferDescriptor = WGPUCommandBufferDescriptor;
/// Describes a `CommandEncoder`.
alias CommandEncoderDescriptor = WGPUCommandEncoderDescriptor;
alias CompilationMessage = WGPUCompilationMessage;
/// Describes a `ComputePass`.
alias ComputePassDescriptor = WGPUComputePassDescriptor;
alias ConstantEntry = WGPUConstantEntry;
/// Extent of a texture related operation.
alias Extent3d = WGPUExtent3D;
alias InstanceDescriptor = WGPUInstanceDescriptor;
/// Represents the sets of limits an adapter/device supports.
///
/// Provided are two sets of defaults:
/// $(UL
///   $(LI `wgpu.limits.defaultLimits`: Set of limits that is guaranteed to work on all modern backends and is guaranteed to be supported by WebGPU. )
///   $(LI `wgpu.limits.downlevelDefaultLimits`: Set of limits that are guaranteed to be compatible with GLES3, WebGL, and D3D11. )
/// )
///
/// Remarks:
/// Limits "better" than the default must be supported by the adapter and requested when requesting a device.
/// If limits "better" than the adapter supports are requested, requesting a device will panic. Once a device is
/// requested, you may only use resources up to the limits requested even if the adapter supports "better" limits.
///
/// Requesting limits that are "better" than you need may cause performance to decrease because the implementation
/// needs to support more than is needed. You should ideally only request exactly what you need.
///
/// See_Also:
/// $(UL
///   $(LI <a href="https://gpuweb.github.io/gpuweb/#dictdef-gpulimits">gpuweb.github.io/gpuweb/#dictdef-gpulimits</a> )
///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Limits.html">wgpu::Limits</a> )
/// )
alias Limits = WGPULimits;
alias MultisampleState = WGPUMultisampleState;
/// Origin of a copy to/from a texture.
alias Origin3d = WGPUOrigin3D;
/// Describes a `PipelineLayout`.
alias PipelineLayoutDescriptor = WGPUPipelineLayoutDescriptor;
alias PrimitiveDepthClampingState = WGPUPrimitiveDepthClampingState;
alias PrimitiveState = WGPUPrimitiveState;
alias QuerySetDescriptor = WGPUQuerySetDescriptor;
alias RenderBundleDescriptor = WGPURenderBundleDescriptor;
alias RenderBundleEncoderDescriptor = WGPURenderBundleEncoderDescriptor;
/// Describes a depth stencil attachment to a `RenderPass`.
alias RenderPassDepthStencilAttachment = WGPURenderPassDepthStencilAttachment;
alias RequestAdapterOptions = WGPURequestAdapterOptions;
alias SamplerBindingLayout = WGPUSamplerBindingLayout;
/// Describes a `Sampler`.
alias SamplerDescriptor = WGPUSamplerDescriptor;
alias ShaderModuleDescriptor = WGPUShaderModuleDescriptor;
alias ShaderModuleSPIRVDescriptor = WGPUShaderModuleSPIRVDescriptor;
alias ShaderModuleWGSLDescriptor = WGPUShaderModuleWGSLDescriptor;
alias StencilFaceState = WGPUStencilFaceState;
alias StorageTextureBindingLayout = WGPUStorageTextureBindingLayout;
alias SurfaceDescriptor = WGPUSurfaceDescriptor;
alias SurfaceDescriptorFromCanvasHTMLSelector = WGPUSurfaceDescriptorFromCanvasHTMLSelector;
alias SurfaceDescriptorFromMetalLayer = WGPUSurfaceDescriptorFromMetalLayer;
alias SurfaceDescriptorFromWindowsHWND = WGPUSurfaceDescriptorFromWindowsHWND;
alias SurfaceDescriptorFromXlib = WGPUSurfaceDescriptorFromXlib;
/// Describes a `SwapChain`.
alias SwapChainDescriptor = WGPUSwapChainDescriptor;
alias TextureBindingLayout = WGPUTextureBindingLayout;
/// Layout of a texture in a buffer's memory.
alias TextureDataLayout = WGPUTextureDataLayout;
/// Describes a `TextureView`.
alias TextureViewDescriptor = WGPUTextureViewDescriptor;
alias VertexAttribute = WGPUVertexAttribute;
/// Describes a `BindGroup`.
alias BindGroupDescriptor = WGPUBindGroupDescriptor;
/// Describes a single binding inside a bind group.
alias BindGroupLayoutEntry = WGPUBindGroupLayoutEntry;
alias BlendState = WGPUBlendState;
alias CompilationInfo = WGPUCompilationInfo;
alias DepthStencilState = WGPUDepthStencilState;
// TODO: View of a buffer which can be used to copy to/from a texture.
/// View of a texture which can be used to copy to/from a buffer.
alias ImageCopyBuffer = WGPUImageCopyBuffer;
/// View of a texture which can be used to copy to/from a texture.
alias ImageCopyTexture = WGPUImageCopyTexture;
alias ProgrammableStageDescriptor = WGPUProgrammableStageDescriptor;
/// Describes a color attachment to a `RenderPass`.
alias RenderPassColorAttachment = WGPURenderPassColorAttachment;
alias RequiredLimits = WGPURequiredLimits;
alias SupportedLimits = WGPUSupportedLimits;
/// Describes a `Texture`.
alias TextureDescriptor = WGPUTextureDescriptor;
alias VertexBufferLayout = WGPUVertexBufferLayout;
/// Describes a `BindGroupLayout`.
alias BindGroupLayoutDescriptor = WGPUBindGroupLayoutDescriptor;
alias ColorTargetState = WGPUColorTargetState;
/// Describes a `ComputePipeline`.
alias ComputePipelineDescriptor = WGPUComputePipelineDescriptor;
alias DeviceDescriptor = WGPUDeviceDescriptor;
/// Describes the attachments of a `RenderPass`.
alias RenderPassDescriptor = WGPURenderPassDescriptor;
alias VertexState = WGPUVertexState;
alias FragmentState = WGPUFragmentState;
/// Describes a `RenderPipeline`.
alias RenderPipelineDescriptor = WGPURenderPipelineDescriptor;
alias AdapterExtras = WGPUAdapterExtras;
alias DeviceExtras = WGPUDeviceExtras;

// Enumerations
private mixin template EnumAlias(T) if (is(T == enum)) {
  enum wgpuPrefix = "WGPU";
  enum baseName = __traits(identifier, T);
  enum name = baseName[wgpuPrefix.length .. $];
  enum memberPrefix = baseName ~ "_";

  private static string _memberMixin(string member) {
    import std.ascii : isDigit, toLower;
    const unprefixedMember = member[memberPrefix.length .. $];
    // Guard against invalid identifiers
    string idiomaticMember = unprefixedMember[0].isDigit
      ? "_" ~ unprefixedMember
      : unprefixedMember[0].toLower ~ unprefixedMember[1..$];
    // Guard against D keywords
    idiomaticMember = idiomaticMember == "null" || idiomaticMember == "float" || idiomaticMember == "uint"
      ? idiomaticMember ~ "_"
      : idiomaticMember;
    // Fix case of "BC", "RG", "RGB", "RGBA", and "BGRA" prefixes
    if (idiomaticMember.length > 4) {
      if (idiomaticMember[0..4] == "bGRA") idiomaticMember = "bgra" ~ idiomaticMember[4..$];
      else if (idiomaticMember[0..4] == "rGBA") idiomaticMember = "rgba" ~ idiomaticMember[4..$];
      else if (idiomaticMember[0..3] == "rGB") idiomaticMember = "rgb" ~ idiomaticMember[3..$];
      else if (idiomaticMember[0..2] == "rG") idiomaticMember = "rg" ~ idiomaticMember[2..$];
      else if (idiomaticMember[0..2] == "bC") idiomaticMember = "bc" ~ idiomaticMember[2..$];
    }
    return "  " ~ idiomaticMember ~ " = cast(" ~ name ~ ") " ~ member ~ `,`;
  }

  private static string _enumMixin() {
    import std.array : join;

    string[] enumeration;
    enumeration ~= "enum " ~ name ~ " : " ~ baseName ~ " {";
    static foreach (member; __traits(allMembers, T)) {
      enumeration ~= _memberMixin(member);
    }
    enumeration ~= "}";
    return enumeration.join("\n");
  }

  mixin(_enumMixin());
}

mixin EnumAlias!WGPUAdapterType;
mixin EnumAlias!WGPUAddressMode;
mixin EnumAlias!WGPUBackendType;
mixin EnumAlias!WGPUBlendFactor;
mixin EnumAlias!WGPUBlendOperation;
mixin EnumAlias!WGPUBufferBindingType;
mixin EnumAlias!WGPUBufferMapAsyncStatus;
mixin EnumAlias!WGPUCompareFunction;
mixin EnumAlias!WGPUCompilationMessageType;
mixin EnumAlias!WGPUCreatePipelineAsyncStatus;
mixin EnumAlias!WGPUCullMode;
mixin EnumAlias!WGPUDeviceLostReason;
mixin EnumAlias!WGPUErrorFilter;
mixin EnumAlias!WGPUErrorType;
/// Features that are not guaranteed to be supported.
///
/// These are either part of the webgpu standard, or are extension features supported by wgpu when targeting native.
///
/// If you want to use a feature, you need to first verify that the adapter supports the feature. If the adapter
/// does not support the feature, requesting a device with it enabled will panic.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Features.html">wgpu::Features</a>
mixin EnumAlias!WGPUFeatureName;
mixin EnumAlias!WGPUFilterMode;
mixin EnumAlias!WGPUFrontFace;
mixin EnumAlias!WGPUIndexFormat;
mixin EnumAlias!WGPULoadOp;
mixin EnumAlias!WGPUPipelineStatisticName;
mixin EnumAlias!WGPUPowerPreference;
mixin EnumAlias!WGPUPresentMode;
mixin EnumAlias!WGPUPrimitiveTopology;
mixin EnumAlias!WGPUQueryType;
mixin EnumAlias!WGPUQueueWorkDoneStatus;
mixin EnumAlias!WGPURequestAdapterStatus;
mixin EnumAlias!WGPURequestDeviceStatus;
mixin EnumAlias!WGPUSType;
mixin EnumAlias!WGPUSamplerBindingType;
mixin EnumAlias!WGPUStencilOperation;
mixin EnumAlias!WGPUStorageTextureAccess;
mixin EnumAlias!WGPUStoreOp;
mixin EnumAlias!WGPUTextureAspect;
mixin EnumAlias!WGPUTextureComponentType;
mixin EnumAlias!WGPUTextureDimension;
mixin EnumAlias!WGPUTextureFormat;
mixin EnumAlias!WGPUTextureSampleType;
mixin EnumAlias!WGPUTextureViewDimension;
mixin EnumAlias!WGPUVertexFormat;
mixin EnumAlias!WGPUVertexStepMode;
/// Different ways that you can use a buffer.
///
/// The usages determine what kind of memory the buffer is allocated from and what actions the buffer can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferUsages.html">wgpu::BufferUsages</a>
mixin EnumAlias!WGPUBufferUsage;
mixin EnumAlias!WGPUColorWriteMask;
mixin EnumAlias!WGPUMapMode;
/// Describes the shader stages that a binding will be visible from.
///
/// These can be combined in a bitwise combination.
///
/// For example, something that is visible from both vertex and fragment shaders can be defined as:
///
/// `ShaderStage.vertex | ShaderStage.fragment`
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ShaderStages.html">wgpu::ShaderStages</a>
mixin EnumAlias!WGPUShaderStage;
/// Different ways that you can use a texture.
///
/// The usages determine what kind of memory the texture is allocated from and what actions the texture can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.TextureUsages.html">wgpu::TextureUsages</a>
mixin EnumAlias!WGPUTextureUsage;

extern (C) private void wgpu_request_adapter_callback(
  WGPURequestAdapterStatus status, WGPUAdapter id, const char* message, void* data
) {
  import std.conv : asOriginalType;
  import std.string : fromStringz;

  assert(status == RequestAdapterStatus.success.asOriginalType);
  assert(data !is null);
  auto adapter = cast(Adapter*) data;
  assert(id !is null);
  adapter.id = id;
  debug import std.stdio : writeln;
  debug if (message !is null) message.fromStringz.to!string.writeln;
}

extern (C) private void wgpu_request_device_callback(
  WGPURequestDeviceStatus status, WGPUDevice id, const char* message, void* data
) {
  import std.conv : asOriginalType;
  import std.string : fromStringz;

  assert(status == RequestDeviceStatus.success.asOriginalType);
  assert(data !is null);
  auto device = cast(Device*) data;
  assert(id !is null);
  device.id = id;
  debug import std.stdio : writeln;
  debug if (message !is null) message.fromStringz.to!string.writeln;
}

/// Context for all other wgpu objects. Instance of wgpu.
///
/// This is the first thing you create when using wgpu. Its primary use is to create `Adapter`s and `Surface`s.
///
/// Does not have to be kept alive.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Instance.html">wgpu::Instance</a>
struct Instance {
  import std.typecons : Flag, No;

  /// Handle identifier.
  WGPUInstance id;

  @disable this();
  private this(WGPUInstance id) {
    this.id = id;
  }

  /// Create a new instance of wgpu.
  static Instance create() {
    assert(0, "Unimplemented in wgpu-native!");
    // auto desc = InstanceDescriptor();
    // return Instance(wgpuCreateInstance(&desc));
  }

  /// Retrieves all available `Adapter`s that match the given `Backends`.
  ///
  /// Params:
  /// backends = Backends from which to enumerate adapters.
  static @property Adapter[] adapters(BackendType backends = BackendType.null_) {
    assert(backends >= 0);
    assert(0, "Unimplemented!");
    // TODO: Implement adapter enumerator as a custom range
  }

  /// Retrieves a new Adapter, asynchronously.
  ///
  /// Some options are “soft”, so treated as non-mandatory. Others are “hard”.
  ///
  /// Remarks:
  /// Use `Adapter.ready` to determine whether an Adapter was successfully requested.
  static Adapter* requestAdapter(
    Surface* compatibleSurface, PowerPreference powerPreference = PowerPreference.highPerformance,
    Flag!"forceFallbackAdapter" forceFallbackAdapter = No.forceFallbackAdapter
  ) {
    return requestAdapter(RequestAdapterOptions(
      null,
      compatibleSurface is null ? null : compatibleSurface.id,
      powerPreference, forceFallbackAdapter
    ));
  }
  /// ditto
  static Adapter* requestAdapter(RequestAdapterOptions options) @trusted {
    auto adapter = new Adapter;
    wgpuInstanceRequestAdapter(null, &options, &wgpu_request_adapter_callback, adapter);
    return adapter;
  }
}

/// A handle to a physical graphics and/or compute device.
///
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Adapter.html">wgpu::Adapter</a>
struct Adapter {
  /// Handle identifier.
  WGPUAdapter id;

  /// Whether this Adapter handle has finished being requested and is ready for use.
  bool ready() @property const {
    return id !is null;
  }

  /// Information about this Adapter.
  AdapterProperties properties() {
    assert(ready);
    AdapterProperties properties;
    wgpuAdapterGetProperties(id, &properties);
    return properties;
  }

  /// List all features that are supported with this adapter.
  ///
  /// Features must be explicitly requested in `Adapter.requestDevice` in order to use them.
  FeatureName[] features() {
    assert(ready);
    // TODO: Watch https://github.com/gfx-rs/wgpu-native/issues/156 for `wgpuAdapterHasFeature` impl
    assert(0, "Unimplemented in wgpu-native, see https://github.com/gfx-rs/wgpu-native/issues/156");
    // FeatureName[] supported;
    // foreach (feature; FeatureName.min..FeatureName.max) {
    //   if (wgpuAdapterHasFeature(id, feature)) supported ~= feature;
    // }
    // return supported;
  }

  /// List the "best" limits that are supported by this adapter.
  ///
  /// Limits must be explicitly requested in `Adapter.requestDevice` to set the values that you are allowed to use.
  Limits limits() {
    assert(ready);
    SupportedLimits limits;
    // https://github.com/gfx-rs/wgpu-native/blob/9d962ef667ef6006cca7bac7489d5bf303a2a244/src/device.rs#L119
    // TODO: assert(wgpuAdapterGetLimits(id, &limits), "Could not retreive adapter limits");
    wgpuAdapterGetLimits(id, &limits);
    return limits.limits;
  }

  /// Requests a connection to a physical device, creating a logical device.
  ///
  /// Params:
  /// limits = Set of required limits the device must supports.
  /// label = Optional label for the `Device`.
  Device* requestDevice(const Limits limits, string label = fullyQualifiedName!Device) {
    assert(ready);
    auto device = new Device(null, label);
    const WGPUDeviceExtras extras = {
      chain: WGPUChainedStruct(null, cast(WGPUSType) WGPUNativeSType.WGPUSType_DeviceExtras),
      label: label.toStringz,
      tracePath: null
    };
    WGPURequiredLimits requiredLimits = { limits: limits };
    DeviceDescriptor desc = { nextInChain: cast(const(WGPUChainedStruct)*) &extras, requiredLimits: &requiredLimits };
    wgpuAdapterRequestDevice(id, &desc, &wgpu_request_device_callback, device);
    return device;
  }
}

/// An open connection to a graphics and/or compute device.
///
/// The `Device` is the responsible for the creation of most rendering and compute resources, as well as exposing `Queue` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Device.html">wgpu::Device</a>
struct Device {
  import std.typecons : Flag, No;

  /// Handle identifier.
  WGPUDevice id;
  /// Label for this Device.
  string label;

  /// Release the given handle.
  void destroy() {
    if (ready) wgpuDeviceDrop(id);
    id = null;
  }

  /// Whether this Device handle is valid and ready for use.
  ///
  /// If `false`, `Adapter.requestDevice` likely failed.
  bool ready() @property const {
    return id !is null;
  }

  /// List all limits that were requested of this device.
  ///
  /// If any of these limits are exceeded, functions may panic.
  Limits limits() {
    WGPUSupportedLimits limits;
    // https://github.com/gfx-rs/wgpu-native/blob/9d962ef667ef6006cca7bac7489d5bf303a2a244/src/device.rs#L132
    // TODO: assert(wgpuDeviceGetLimits(id, &limits), "Could not retreive device limits");
    wgpuDeviceGetLimits(id, &limits);
    return limits.limits;
  }

  /// Obtains a queue which can accept `CommandBuffer` submissions.
  Queue queue() {
    return Queue(wgpuDeviceGetQueue(id));
  }

  /// Check for resource cleanups and mapping callbacks.
  /// Params:
  /// forceWait = Whether or not the call should block.
  void poll(Flag!"forceWait" forceWait = No.forceWait) {
    wgpuDevicePoll(id, forceWait);
  }

  /// Creates a shader module from SPIR-V source code.
  ShaderModule createShaderModule(const byte[] spv) {
    import std.algorithm.iteration : map;
    import std.array : array;

    const bytes = spv.map!(byte_ => byte_.to!(const uint)).array;
    ShaderModuleSPIRVDescriptor spirv = {
      chain: WGPUChainedStruct(null, cast(WGPUSType) SType.shaderModuleSPIRVDescriptor),
      codeSize: spv.length.to!uint,
      code: bytes.ptr
    };
    auto desc = ShaderModuleDescriptor(cast(const(WGPUChainedStruct)*) &spirv);
    return ShaderModule(wgpuDeviceCreateShaderModule(id, &desc));
  }

  /// Creates an empty `CommandEncoder`.
  ///
  /// Params:
  /// label = Optional, human-readable debug label for the command encoder.
  CommandEncoder createCommandEncoder(string label = null) {
    return createCommandEncoder(CommandEncoderDescriptor(null, label is null ? null : label.toStringz));
  }
  /// Creates an empty `CommandEncoder`.
  CommandEncoder createCommandEncoder(const CommandEncoderDescriptor descriptor) {
    return CommandEncoder(wgpuDeviceCreateCommandEncoder(id, &descriptor), descriptor);
  }

  /// Creates a new bind group.
  BindGroup createBindGroup(BindGroupDescriptor descriptor) {
    return BindGroup(wgpuDeviceCreateBindGroup(id, cast(BindGroupDescriptor*) &descriptor), descriptor);
  }

  /// Creates a bind group layout.
  BindGroupLayout createBindGroupLayout(const BindGroupLayoutDescriptor descriptor) {
    return BindGroupLayout(wgpuDeviceCreateBindGroupLayout(id, &descriptor), descriptor);
  }

  /// Creates a bind group layout.
  PipelineLayout createPipelineLayout(const PipelineLayoutDescriptor descriptor) {
    return PipelineLayout(wgpuDeviceCreatePipelineLayout(id, &descriptor), descriptor);
  }

  /// Creates a render pipeline.
  RenderPipeline createRenderPipeline(RenderPipelineDescriptor descriptor) {
    return RenderPipeline(wgpuDeviceCreateRenderPipeline(id, cast(RenderPipelineDescriptor*) &descriptor), descriptor);
  }

  /// Creates a compute pipeline.
  ComputePipeline createComputePipeline(ComputePipelineDescriptor descriptor) {
    return ComputePipeline(
      wgpuDeviceCreateComputePipeline(id, cast(ComputePipelineDescriptor*) &descriptor), descriptor
    );
  }

  /// Creates a new buffer.
  ///
  /// Params:
  /// usage = How the buffer shall be used.
  /// size = Size of the buffer, in bytes.
  /// mappedAtCreation = Whether the buffer is mapped to local memory upon creation.
  /// label = Optional, human-readable debug label for the buffer.
  Buffer createBuffer(
    BufferUsage usage, uint size,
    Flag!"mappedAtCreation" mappedAtCreation = No.mappedAtCreation,
    string label = null
  ) {
    return createBuffer(BufferDescriptor(null, label is null ? null : label.toStringz, usage, size, mappedAtCreation));
  }
  /// Creates a new buffer.
  Buffer createBuffer(const BufferDescriptor descriptor) {
    return Buffer(wgpuDeviceCreateBuffer(id, &descriptor), descriptor);
  }

  /// Creates a new `Texture`.
  ///
  /// Remarks: The created texture will have one <a href="https://en.wikipedia.org/wiki/Mipmap">mip level</a> and a single sample used in fragments.
  ///
  /// Params:
  /// width = Width of the texture.
  /// height = Height of the texture.
  /// format = Bit-level format of the texture's data.
  /// usage = How the texture shall be used.
  /// dimension = Dimesnionality of the texture, e.g. 2D or 3D. Defaults to 2D.
  /// mipLevelCount = Number of <a href="https://en.wikipedia.org/wiki/Mipmap">mipmapping levels</a> of this texture, usually used to reduce aliasing effects. Defaults to one.
  /// sampleCount = Number of samples used in each fragment. Defaults to one.
  /// depthOrArrayLayers = Depth/total array layers of the texture. Defaults to one. See `Limits.maxTextureArrayLayers`.
  /// label = Optional, human-readable debug label for the texture.
  Texture createTexture(
    uint width, uint height,
    TextureFormat format, TextureUsage usage,
    TextureDimension dimension = TextureDimension._2D,
    uint mipLevelCount = 1,
    uint sampleCount = 1,
    uint depthOrArrayLayers = 1,
    string label = null
  ) {
    return createTexture(TextureDescriptor(
      null,
      label is null ? null : label.toStringz,
      usage, dimension,
      Extent3d(width, height, depthOrArrayLayers),
      format,
      mipLevelCount,
      sampleCount
    ));
  }
  /// Creates a new `Texture`.
  ///
  /// Params:
  /// extent = Size and depth/total array layers of the texture. See `Limits.maxTextureArrayLayers`.
  /// format = Bit-level format of the texture's data.
  /// usage = How the texture shall be used.
  /// dimension = Dimesnionality of the texture, e.g. 2D or 3D. Defaults to 2D.
  /// mipLevelCount = Number of <a href="https://en.wikipedia.org/wiki/Mipmap">mipmapping levels</a> of this texture, usually used to reduce aliasing effects. Defaults to one.
  /// sampleCount = Number of samples used in each fragment. Defaults to one.
  /// label = Optional, human-readable debug label for the texture.
  Texture createTexture(
    Extent3d extent, TextureFormat format, TextureUsage usage,
    TextureDimension dimension = TextureDimension._2D,
    uint mipLevelCount = 1,
    uint sampleCount = 1,
    string label = null
  ) {
    assert(extent.depthOrArrayLayers > 0, "Textures must have at least one texel/array layer");
    assert(mipLevelCount > 0, "Textures must have at least one mipmap level");
    assert(sampleCount > 0, "Textures must have a non-zero sample count");
    debug import std.math : isPowerOf2;
    debug assert(sampleCount.isPowerOf2, "Texture sample count must be a power of two");
    return createTexture(TextureDescriptor(
      null, label is null ? null : label.toStringz, usage, dimension, extent, format, mipLevelCount, sampleCount
    ));
  }
  /// Creates a new `Texture`.
  ///
  /// Params:
  /// descriptor = Specifies the general format of the texture.
  Texture createTexture(const TextureDescriptor descriptor) {
    return Texture(wgpuDeviceCreateTexture(id, &descriptor), descriptor);
  }

  /// Creates a new `Sampler`.
  ///
  /// Params:
  /// descriptor = Specifies the behavior of the sampler.
  Sampler createSampler(const SamplerDescriptor descriptor) {
    return Sampler(wgpuDeviceCreateSampler(id, &descriptor), descriptor);
  }

  /// Create a new `SwapChain` which targets `surface`.
  SwapChain createSwapChain(const Surface surface, const SwapChainDescriptor descriptor) {
    return SwapChain(wgpuDeviceCreateSwapChain(id, cast(WGPUSurface) surface.id, &descriptor), descriptor);
  }
}

/// A handle to a presentable surface.
///
/// A Surface represents a platform-specific surface (e.g. a window) to which rendered images may be presented.
/// A Surface may be created with `Surface.create`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Surface.html">wgpu::Surface</a>
struct Surface {
  import std.conv : asOriginalType;

  /// Handle identifier.
  WGPUSurface id;

  version (OSX) {
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(Instance instance, void* layer, string label = null) {
      auto metalLayer = SurfaceDescriptorFromMetalLayer(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromMetalLayer.asOriginalType),
        layer
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &metalLayer, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  }
  version (Windows) {
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(Instance instance, void* _hinstance, void* hwnd, string label = null) {
      auto windowsHwnd = SurfaceDescriptorFromWindowsHwnd(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromWindowsHwnd.asOriginalType),
        _hinstance, hwnd
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &windowsHwnd, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  }
  version (linux) {
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(Instance instance, void* display, uint window, string label = null) {
      auto xlib = SurfaceDescriptorFromXlib(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromXlib.asOriginalType),
        display, window
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &xlib, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  }
  version (D_Ddoc) {
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(Instance instance, void* layer, string label = null);
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(Instance instance, void* _hinstance, void* hwnd, string label = null);
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(Instance instance, void* display, uint window, string label = null);
    // TODO: Support Wayland with a `linux-wayland` version config once upstream wgpu-native supports it
  }

  /// Retreive an optimal texture format for this `Surface`.
  TextureFormat preferredFormat(Adapter adapter) {
    assert(id !is null);
    assert(adapter.ready);
    return wgpuSurfaceGetPreferredFormat(id, adapter.id).asOriginalType.to!TextureFormat;
  }
}

/// A handle to a swap chain.
///
/// A `SwapChain` represents the image or series of images that will be presented to a `Surface`.
/// A `SwapChain` may be created with `Device.createSwapChain`.
/// See_Also: <a href="https://docs.rs/wgpu/0.9.0/wgpu/struct.SwapChain.html">wgpu::SwapChain</a>
struct SwapChain {
  /// Handle identifier.
  WGPUSwapChain id;
  /// Describes this `SwapChain.`
  SwapChainDescriptor descriptor;

  /// Returns the next texture to be presented by the swapchain for drawing.
  TextureView getNextTexture() {
    return TextureView(wgpuSwapChainGetCurrentTextureView(id));
  }

  ///
  void present() {
    wgpuSwapChainPresent(id);
  }
}

/// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
enum BufferMapAsyncStatus {
  success = 0,
  error = 1,
  unknown = 2,
  contextLost = 3
}

extern (C) private void wgpuBufferMapCallback(WGPUBufferMapAsyncStatus status, void* data) {
  assert(data !is null);
  auto buffer = cast(Buffer*) data;
  assert(buffer.id !is null);

  buffer.status = status.to!int.to!BufferMapAsyncStatus;
}

/// A handle to a GPU-accessible buffer.
///
/// Created with `Device.createBuffer`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Buffer.html">wgpu::Buffer</a>
struct Buffer {
  /// Handle identifier.
  WGPUBuffer id;
  /// Describes this `Buffer`.
  BufferDescriptor descriptor;
  /// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  BufferMapAsyncStatus status = BufferMapAsyncStatus.unknown;

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuBufferDestroy(id);
    id = null;
  }

  /// Get the sliced `Buffer` data requested by either `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  ubyte[] getMappedRange(size_t start, size_t size) {
    assert(status == BufferMapAsyncStatus.success);

    auto data = wgpuBufferGetMappedRange(id, start, size);
    return cast(ubyte[]) data[0 .. size];
  }

  /// Map the buffer for reading asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapReadAsync(size_t start, size_t size) {
    wgpuBufferMapAsync(id, MapMode.read, start, size, &wgpuBufferMapCallback, &this);
  }

  /// Map the buffer for writing asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapWriteAsync(size_t start, size_t size) {
    wgpuBufferMapAsync(id, MapMode.write, start, size, &wgpuBufferMapCallback, &this);
  }

  /// Flushes any pending write operations and unmaps the buffer from host memory.
  void unmap() {
    wgpuBufferUnmap(id);
  }
}

/// A handle to a texture on the GPU.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Texture.html">wgpu::Texture</a>
// TODO: Expand docs akin to https://veldrid.dev/articles/textures.html
struct Texture {
  /// Handle identifier.
  WGPUTexture id;
  /// Describes this `Texture`.
  TextureDescriptor descriptor;


  ///
  Extent3d size() @property const {
    return descriptor.size;
  }
  ///
  uint width() @property const {
    return descriptor.size.width;
  }
  ///
  uint height() @property const {
    return descriptor.size.height;
  }

  /// Bytes per “block” of this texture, in bytes.
  ///
  /// A “block” is one pixel or compressed block of a texture.
  ///
  /// See_Also:
  /// $(UL
  ///   $(LI `TextureFormat` )
  ///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a> )
  /// )
  uint bytesPerBlock() @property const {
    switch (descriptor.format) {
      // 8 * 1 / 8
      case TextureFormat.r8Snorm:
      case TextureFormat.r8Sint:
      case TextureFormat.r8Unorm:
      case TextureFormat.r8Uint:
      case TextureFormat.stencil8:
        return 1;
      // 8 * 2 / 8
      case TextureFormat.rg8Uint:
      case TextureFormat.rg8Unorm:
      case TextureFormat.rg8Snorm:
      case TextureFormat.rg8Sint:
      // 16 * 1 / 8
      case TextureFormat.r16Uint:
      case TextureFormat.r16Sint:
      case TextureFormat.r16Float:
      case TextureFormat.depth16Unorm:
        return 2;
      // 8 * 4 / 8
      case TextureFormat.rgba8Uint:
      case TextureFormat.rgba8Snorm:
      case TextureFormat.rgba8Sint:
      case TextureFormat.rgba8Unorm:
      case TextureFormat.rgba8UnormSrgb:
      case TextureFormat.bgra8Unorm:
      case TextureFormat.bgra8UnormSrgb:
      // 32 * 1 / 8
      case TextureFormat.r32Float:
      case TextureFormat.r32Uint:
      case TextureFormat.r32Sint:
      case TextureFormat.depth32Float:
      // 16 * 2 / 8
      case TextureFormat.rg16Uint:
      case TextureFormat.rg16Sint:
      case TextureFormat.rg16Float:
        return 4;
      // 32 * 2 / 8
      case TextureFormat.rg32Float:
      case TextureFormat.rg32Uint:
      case TextureFormat.rg32Sint:
      // 16 * 4 / 8
      case TextureFormat.rgba16Uint:
      case TextureFormat.rgba16Sint:
      case TextureFormat.rgba16Float:
        return 8;
      // 32 * 4 / 8
      case TextureFormat.rgba32Float:
      case TextureFormat.rgba32Uint:
      case TextureFormat.rgba32Sint:
      // Compressed, 4 pixels per block
      case TextureFormat.bc3RGBAUnorm:
      case TextureFormat.bc3RGBAUnormSrgb:
        return 16;
      case TextureFormat.rgb10A2Unorm:
      case TextureFormat.rg11B10Ufloat:
      case TextureFormat.rgb9E5Ufloat:
      case TextureFormat.bc1RGBAUnorm:
      case TextureFormat.bc1RGBAUnormSrgb:
      case TextureFormat.bc2RGBAUnorm:
      case TextureFormat.bc2RGBAUnormSrgb:
      case TextureFormat.bc4RUnorm:
      case TextureFormat.bc4RSnorm:
      case TextureFormat.bc5RGUnorm:
      case TextureFormat.bc5RGSnorm:
      case TextureFormat.bc6HRGBUfloat:
      case TextureFormat.bc6HRGBFloat:
      case TextureFormat.bc7RGBAUnorm:
      case TextureFormat.bc7RGBAUnormSrgb:
        // FIXME: Supply block sizes for these texture formats
        assert(0, "Unknown block size in bytes of " ~ descriptor.format.stringof);
      // QUESTION: Depth formats of _at least_ 24 bits, therefore there's no guarenteed block size?
      case TextureFormat.depth24Plus:
      case TextureFormat.depth24PlusStencil8:
      case TextureFormat.undefined:
        assert(0, "Undefined block size");
      default: assert(0, "Unknown texture format");
    }
  }

  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a>
  uint pixelsPerBlock() @property const {
    final switch (descriptor.format) {
      case TextureFormat.r8Snorm:
      case TextureFormat.r8Sint:
      case TextureFormat.r8Unorm:
      case TextureFormat.r8Uint:
      case TextureFormat.stencil8:
      case TextureFormat.rg8Uint:
      case TextureFormat.rg8Unorm:
      case TextureFormat.rg8Snorm:
      case TextureFormat.rg8Sint:
      case TextureFormat.r16Uint:
      case TextureFormat.r16Sint:
      case TextureFormat.r16Float:
      case TextureFormat.rgba8Uint:
      case TextureFormat.rgba8Snorm:
      case TextureFormat.rgba8Sint:
      case TextureFormat.rgba8Unorm:
      case TextureFormat.rgba8UnormSrgb:
      case TextureFormat.bgra8Unorm:
      case TextureFormat.bgra8UnormSrgb:
      case TextureFormat.r32Float:
      case TextureFormat.r32Uint:
      case TextureFormat.r32Sint:
      case TextureFormat.rg16Uint:
      case TextureFormat.rg16Sint:
      case TextureFormat.rg16Float:
      case TextureFormat.rg32Float:
      case TextureFormat.rg32Uint:
      case TextureFormat.rg32Sint:
      case TextureFormat.rgba16Uint:
      case TextureFormat.rgba16Sint:
      case TextureFormat.rgba16Float:
      case TextureFormat.rgba32Float:
      case TextureFormat.rgba32Uint:
      case TextureFormat.rgba32Sint:
      case TextureFormat.rgb10A2Unorm:
      case TextureFormat.rg11B10Ufloat:
      case TextureFormat.rgb9E5Ufloat:
        return 1;
      // BC3 compression, 4 pixels per block
      case TextureFormat.bc3RGBAUnorm:
      case TextureFormat.bc3RGBAUnormSrgb:
        return 4;
      case TextureFormat.bc1RGBAUnorm:
      case TextureFormat.bc1RGBAUnormSrgb:
      case TextureFormat.bc2RGBAUnorm:
      case TextureFormat.bc2RGBAUnormSrgb:
      case TextureFormat.bc4RUnorm:
      case TextureFormat.bc4RSnorm:
      case TextureFormat.bc5RGUnorm:
      case TextureFormat.bc5RGSnorm:
      case TextureFormat.bc6HRGBUfloat:
      case TextureFormat.bc6HRGBFloat:
      case TextureFormat.bc7RGBAUnorm:
      case TextureFormat.bc7RGBAUnormSrgb:
        // FIXME: Supply pixel compression ratios for these texture formats
        assert(0, "Unknown compression ratio of " ~ descriptor.format.stringof);
      // QUESTION: Depth formats of _at least_ 24 bits, therefore there's no guarenteed block size?
      case TextureFormat.undefined:
      case TextureFormat.depth16Unorm:
      case TextureFormat.depth32Float:
      case TextureFormat.depth24Plus:
      case TextureFormat.depth24PlusStencil8:
      case TextureFormat.force32:
        assert(0, "Undefined block size");
    }
  }

  /// Size of one row of pixels in this texture, in bytes.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a>
  uint bytesPerRow() @property const {
    return descriptor.size.width * bytesPerBlock;
  }

  /// Size of one row of pixels in this texture, in bytes. Aligned to `COPY_BYTES_PER_ROW_ALIGNMENT`.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a>
  uint paddedBytesPerRow() @property const {
    // https://github.com/rukai/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs#L53
    const alignment = COPY_BYTES_PER_ROW_ALIGNMENT;
    const unpaddedBytesPerRow = this.bytesPerRow;
    auto paddedBytesPerRowPadding = (alignment - unpaddedBytesPerRow % alignment) % alignment;
    return unpaddedBytesPerRow + paddedBytesPerRowPadding;
  }

  /// “Rows” that make up a single “image”.
  ///
  /// A “row” is one row of pixels or compressed blocks in the x direction.
  /// An “image” is one layer in the z direction of a 3D image or 2D array texture.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a>
  uint rowsPerImage() @property const {
    return height / pixelsPerBlock;
  }

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuTextureDestroy(id);
    id = null;
  }

  /// Creates a view of this texture.
  TextureView createView(const TextureViewDescriptor descriptor) inout @trusted {
    assert(id !is null);
    return TextureView(wgpuTextureCreateView(cast(WGPUTexture) id, &descriptor));
  }

  /// Creates a default view of this whole texture.
  TextureView defaultView() @property const {
    TextureViewDescriptor desc = {
      nextInChain: null,
      label: null,
      format: TextureFormat.undefined,
      dimension: TextureViewDimension.undefined,
      aspect: TextureAspect.all,
      arrayLayerCount: 0,
      baseArrayLayer: 0,
      baseMipLevel: 0,
      mipLevelCount: 0,
    };
    return createView(desc);
  }
}

/// A handle to a texture view.
///
/// A `TextureView` object describes a texture and associated metadata needed by a `RenderPipeline` or `BindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.TextureView.html">wgpu::TextureView</a>
struct TextureView {
  /// Handle identifier.
  WGPUTextureView id;

  /// Release the handle to this texture view.
  void destroy() {
    if (id !is null) wgpuTextureViewDrop(id);
    id = null;
  }
}

/// A handle to a sampler.
///
/// A Sampler object defines how a pipeline will sample from a `TextureView`. Samplers define image
/// filters (including anisotropy) and address (wrapping) modes, among other things.
///
/// See the documentation for `SamplerDescriptor` for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Sampler.html">wgpu::Sampler</a>
struct Sampler {
  /// Handle identifier.
  WGPUSampler id;
  /// Describes this `Sampler`.
  SamplerDescriptor descriptor;
}

/// A Queue executes finished `CommandBuffer` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Queue.html">wgpu::Queue</a>
struct Queue {
  /// Handle identifier.
  WGPUQueue id;

  /// Submits a finished command buffer for execution.
  void submit(CommandBuffer commands) {
    submit([commands]);
  }
  /// Submits a series of finished command buffers for execution.
  void submit(CommandBuffer[] commandBuffers) {
    import std.algorithm.iteration : map;
    import std.array : array;

    const commandBufferIds = commandBuffers.map!(c => c.id).array;
    wgpuQueueSubmit(id, commandBuffers.length.to!uint, commandBufferIds.ptr);
  }
}

/// An opaque handle to a command buffer on the GPU.
///
/// A `CommandBuffer` represents a complete sequence of commands that may be submitted to a command queue with `Queue.submit`.
/// A `CommandBuffer` is obtained by recording a series of commands to a `CommandEncoder` and then calling `CommandEncoder.finish`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.CommandBuffer.html">wgpu::CommandBuffer</a>
struct CommandBuffer {
  /// Handle identifier.
  WGPUCommandBuffer id;
  /// Describes a `CommandBuffer`.
  const CommandBufferDescriptor descriptor;
}

/// A handle to a compiled shader module.
///
/// A `ShaderModule` represents a compiled shader module on the GPU. It can be created by passing valid SPIR-V source code to `Device.createShaderModule`.
/// Shader modules are used to define programmable stages of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ShaderModule.html">wgpu::ShaderModule</a>
// TODO: Add docs akin to https://veldrid.dev/articles/specialization-constants.html
struct ShaderModule {
  /// Handle identifier.
  WGPUShaderModule id;

  /// Release the handle to this shader.
  void destroy() {
    if (id !is null) wgpuShaderModuleDrop(id);
    id = null;
  }
}

/// An object that encodes GPU operations.
///
/// A `CommandEncoder` can record `RenderPass`es, `ComputePass`es, and transfer operations between driver-managed resources like `Buffer`s and `Texture`s.
///
/// When finished recording, call `CommandEncoder.finish` to obtain a `CommandBuffer` which may be submitted for execution.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.CommandEncoder.html">wgpu::CommandEncoder</a>
struct CommandEncoder {
  /// Handle identifier.
  WGPUCommandEncoder id;
  /// Describes a `CommandEncoder`.
  const CommandEncoderDescriptor descriptor;

  /// Finishes recording and returns a `CommandBuffer` that can be submitted for execution.
  CommandBuffer finish() {
    auto commandBufferDescriptor = CommandBufferDescriptor();
    return CommandBuffer(wgpuCommandEncoderFinish(id, &commandBufferDescriptor), commandBufferDescriptor);
  }

  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  ///
  /// Params:
  /// colorAttachments = Color attachments of the render pass.
  /// label = Optional, human-readable debug label for the render pass.
  RenderPass beginRenderPass(
    RenderPassColorAttachment[] colorAttachments,
    string label = null
  ) {
    return beginRenderPass(colorAttachments, null, label);
  }
  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  ///
  /// Params:
  /// colorAttachment = Color attachment of the render pass.
  /// depthStencilAttachment = Optional depth stencil attachment.
  /// label = Optional, human-readable debug label for the render pass.
  RenderPass beginRenderPass(
    RenderPassColorAttachment colorAttachment,
    RenderPassDepthStencilAttachment* depthStencilAttachment = null,
    string label = null
  ) {
    return beginRenderPass([colorAttachment], depthStencilAttachment, label);
  }
  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  ///
  /// Params:
  /// colorAttachments = Color attachments of the render pass.
  /// depthStencilAttachment = Optional depth stencil attachment.
  /// label = Optional, human-readable debug label for the render pass.
  RenderPass beginRenderPass(
    RenderPassColorAttachment[] colorAttachments,
    RenderPassDepthStencilAttachment* depthStencilAttachment = null,
    string label = null
  ) {
    assert(colorAttachments.length);
    return beginRenderPass(RenderPassDescriptor(
      null,
      label is null ? null : label.toStringz,
      colorAttachments.length.to!uint,
      colorAttachments.ptr,
      depthStencilAttachment,
      null, // occlusion query set
    ));
  }
  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  RenderPass beginRenderPass(const RenderPassDescriptor descriptor) {
    return RenderPass(wgpuCommandEncoderBeginRenderPass(id, &descriptor));
  }

  /// Begins recording of a compute pass.
  ///
  /// This function returns a `ComputePass` object which records a single compute pass.
  ComputePass beginComputePass(const ComputePassDescriptor descriptor) {
    return ComputePass(wgpuCommandEncoderBeginComputePass(id, &descriptor));
  }

  // TODO: void wgpuCommandEncoderCopyBufferToBuffer(WGPUCommandEncoder commandEncoder, WGPUBuffer source, uint64_t sourceOffset, WGPUBuffer destination, uint64_t destinationOffset, uint64_t size);
  // TODO: void wgpuCommandEncoderCopyBufferToTexture(WGPUCommandEncoder commandEncoder, WGPUImageCopyBuffer const * source, WGPUImageCopyTexture const * destination, WGPUExtent3D const * copySize);

  /// Copy data from a `Texture` to a `Buffer`.
  ///
  /// Remarks: Copies the whole extent of the source `texture`.
  void copyTextureToBuffer(const Texture source, const Buffer destination) {
    copyTextureToBuffer(source, destination, source.descriptor.size);
  }
  /// Copy data from a `Texture` to a `Buffer`.
  void copyTextureToBuffer(const Texture source, const Buffer destination, const Extent3d copySize) {
    copyTextureToBuffer(
      ImageCopyTexture(
        null,
        cast(WGPUTexture) source.id,
        0, // Mip level
        Origin3d(0, 0, 0),
        TextureAspect.all
      ),
      ImageCopyBuffer(
        null,
        TextureDataLayout(
          null,
          0, // Offset
          source.paddedBytesPerRow,
          source.size.depthOrArrayLayers == 1 ? 0 : source.rowsPerImage,
        ),
        cast(WGPUBuffer) destination.id,
      ),
      copySize
    );
  }
  /// Copy data from a texture to a buffer.
  void copyTextureToBuffer(const ImageCopyTexture source, const ImageCopyBuffer destination, const Extent3d copySize) {
    wgpuCommandEncoderCopyTextureToBuffer(id, &source, &destination, &copySize);
  }

  // TODO: void wgpuCommandEncoderCopyTextureToTexture(WGPUCommandEncoder commandEncoder, WGPUImageCopyTexture const * source, WGPUImageCopyTexture const * destination, WGPUExtent3D const * copySize);
}

/// An opaque handle to a binding group.
///
/// A `BindGroup` represents the set of resources bound to the bindings described by a `BindGroupLayout`.
/// It can be created with `Device.createBindGroup`. A `BindGroup` can be bound to a particular `RenderPass`
/// with `RenderPass.setBindGroup`, or to a `ComputePass` with `ComputePass.setBindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BindGroup.html">wgpu::BindGroup</a>
struct BindGroup {
  /// Handle identifier.
  WGPUBindGroup id;
  /// Describes this `BindGroup`.
  BindGroupDescriptor descriptor;
}

/// An opaque handle to a binding group layout.
///
/// A `BindGroupLayout` is a handle to the GPU-side layout of a binding group. It can be used to create
/// a `BindGroupDescriptor` object, which in turn can be used to create a `BindGroup` object with
/// `Device.createBindGroup`. A series of `BindGroupLayout`s can also be used to create a
/// `PipelineLayoutDescriptor`, which can be used to create a `PipelineLayout`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BindGroupLayout.html">wgpu::BindGroupLayout</a>
struct BindGroupLayout {
  /// Handle identifier.
  WGPUBindGroupLayout id;
  /// Describes this `BindGroupLayout`.
  BindGroupLayoutDescriptor descriptor;
}

/// An opaque handle to a pipeline layout describing the available binding groups of a pipeline.
///
/// A `PipelineLayout` object describes the available binding groups of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.PipelineLayout.html">wgpu::PipelineLayout</a>
struct PipelineLayout {
  /// Handle identifier.
  WGPUPipelineLayout id;
  /// Describes this `PipelineLayout`.
  PipelineLayoutDescriptor descriptor;
}

/// A handle to a rendering (graphics) pipeline.
///
/// A `RenderPipeline` object represents a graphics pipeline and its stages, bindings, vertex buffers and targets.
/// A `RenderPipeline` may be created with `Device.createRenderPipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.RenderPipeline.html">wgpu::RenderPipeline</a>
struct RenderPipeline {
  /// Handle identifier.
  WGPURenderPipeline id;
  /// Describes this `RenderPipeline`.
  RenderPipelineDescriptor descriptor;

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuRenderPipelineDrop(id);
    id = null;
  }
}

/// An in-progress recording of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.RenderPass.html">wgpu::RenderPass</a>
struct RenderPass {
  import std.typecons : Flag, Tuple, Yes;

  package WGPURenderPassEncoder instance;
  /// Describes this `RenderPass`.
  RenderPassDescriptor descriptor;

  /// Create a color attachment for a render pass.
  ///
  /// Params:
  /// view = The view to use as an attachment.
  /// loadOp = How data should be read through this attachment.
  /// clearColor = Value with which to fill the given `view` if `loadOp` equals `LoadOp.clear`.
  /// store = Whether data will be written to through this attachment. Defaults to `true`.
  ///
  /// Remarks: The render target must be cleared at least once before its content is loaded.
  /// SeeAlso: `CommandEncoder.beginRenderPass`
  static RenderPassColorAttachment colorAttachment(
    TextureView view, LoadOp loadOp, Color clearColor, Flag!"store" store = Yes.store
  ) {
    return colorAttachment(view, null, loadOp, clearColor, store);
  }
  /// ditto
  ///
  /// Params:
  /// view = The view to use as an attachment.
  /// resolveTarget = The view that will receive the resolved output if multisampling is used.
  /// loadOp = How data should be read through this attachment.
  /// clearColor = Value with which to fill the given `view` if `loadOp` equals `LoadOp.clear`.
  /// store = Whether data will be written to through this attachment. Defaults to `true`.
  static RenderPassColorAttachment colorAttachment(
    TextureView view, TextureView* resolveTarget, LoadOp loadOp, Color clearColor, Flag!"store" store = Yes.store
  ) {
    return RenderPassColorAttachment(
      view.id,
      resolveTarget is null ? null : resolveTarget.id,
      loadOp,
      store ? StoreOp.store : StoreOp.discard,
      clearColor
    );
  }

  ///
  void end() {
    wgpuRenderPassEncoderEndPass(instance);
  }

  // TODO: void wgpuRenderPassEncoderBeginOcclusionQuery(WGPURenderPassEncoder renderPassEncoder, uint32_t queryIndex);
  // TODO: void wgpuRenderPassEncoderEndOcclusionQuery(WGPURenderPassEncoder renderPassEncoder);
  // TODO: void wgpuRenderPassEncoderBeginPipelineStatisticsQuery(WGPURenderPassEncoder renderPassEncoder, WGPUQuerySet querySet, uint32_t queryIndex);
  // TODO: void wgpuRenderPassEncoderEndPipelineStatisticsQuery(WGPURenderPassEncoder renderPassEncoder);
  // TODO: void wgpuRenderPassEncoderExecuteBundles(WGPURenderPassEncoder renderPassEncoder, uint32_t bundlesCount, WGPURenderBundle const * bundles);
  // TODO: void wgpuRenderPassEncoderInsertDebugMarker(WGPURenderPassEncoder renderPassEncoder, char const * markerLabel);
  // TODO: void wgpuRenderPassEncoderPushDebugGroup(WGPURenderPassEncoder renderPassEncoder, char const * groupLabel);
  // TODO: void wgpuRenderPassEncoderPopDebugGroup(WGPURenderPassEncoder renderPassEncoder);
  // See_Also: `QUERY_SIZE`
  // TODO: void wgpuRenderPassEncoderWriteTimestamp(WGPURenderPassEncoder renderPassEncoder, WGPUQuerySet querySet, uint32_t queryIndex);

  /// Sets the active bind group for a given bind group index.
  ///
  /// If the bind group have dynamic offsets, provide them in order of their declaration. These offsets must be aligned to `BIND_BUFFER_ALIGNMENT`.
  void setBindGroup(const uint index, BindGroup bindGroup, const uint[] offsets) {
    wgpuRenderPassEncoderSetBindGroup(instance, index, bindGroup.id, offsets.length.to!uint, offsets.ptr);
  }

  /// Sets the active render pipeline.
  ///
  /// Subsequent draw calls will exhibit the behavior defined by `pipeline`.
  void setPipeline(RenderPipeline pipeline) {
    wgpuRenderPassEncoderSetPipeline(instance, pipeline.id);
  }

  /// Sets the blend color as used by some of the blending modes.
  ///
  /// Subsequent blending tests will test against this value.
  void setBlendConstant(Color color) {
    wgpuRenderPassEncoderSetBlendConstant(instance, &color);
  }

  /// Sets the active index buffer.
  ///
  /// Subsequent calls to `drawIndexed` on this `RenderPass` will use buffer as the source index buffer.
  void setIndexBuffer(Buffer buffer, IndexFormat format, const size_t offset) {
    wgpuRenderPassEncoderSetIndexBuffer(instance, buffer.id, format, offset, buffer.descriptor.size.to!uint);
  }

  /// Sets the active vertex buffers, starting from `startSlot`.
  ///
  /// Each element of `bufferPairs` describes a vertex buffer and an offset in bytes into that buffer.
  /// The offset must be aligned to a multiple of 4 bytes.
  void setVertexBuffers(uint startSlot, Tuple!(Buffer, size_t)[] bufferPairs) {
    // void wgpuRenderPassEncoderSetVertexBuffer(WGPURenderPassEncoder renderPassEncoder, uint32_t slot, WGPUBuffer buffer, uint64_t offset, uint64_t size);
    foreach (bufferPair; bufferPairs) {
      auto buffer = bufferPair[0];
      auto bufferAddress = bufferPair[1];
      wgpuRenderPassEncoderSetVertexBuffer(instance, startSlot, buffer.id, bufferAddress, buffer.descriptor.size);
    }
  }

  /// Sets the scissor region.
  ///
  /// Subsequent draw calls will discard any fragments that fall outside this region.
  void setScissorRect(uint x, uint y, uint w, uint h) {
    wgpuRenderPassEncoderSetScissorRect(instance, x, y, w, h);
  }

  /// Sets the viewport region.
  ///
  /// Subsequent draw calls will draw any fragments in this region.
  void setViewport(float x, float y, float w, float h, float minDepth, float maxDepth) {
    wgpuRenderPassEncoderSetViewport(instance, x, y, w, h, minDepth, maxDepth);
  }

  /// Sets the stencil reference.
  ///
  /// Subsequent stencil tests will test against this value.
  void setStencilReference(uint reference) {
    wgpuRenderPassEncoderSetStencilReference(instance, reference);
  }

  /// Draws primitives from the active vertex buffer(s).
  ///
  /// The active vertex buffers can be set with `RenderPass.setVertexBuffers`.
  void draw(uint[] vertices, uint[] instances) {
    assert(vertices.length);
    assert(instances.length);
    // TODO: void wgpuRenderPassEncoderDraw(WGPURenderPassEncoder renderPassEncoder, uint32_t vertexCount, uint32_t instanceCount, uint32_t firstVertex, uint32_t firstInstance);
  }

  /// Draws indexed primitives using the active index buffer and the active vertex buffers.
  ///
  /// The active index buffer can be set with `RenderPass.setIndexBuffer`, while the active vertex
  /// buffers can be set with `RenderPass.setVertexBuffers`.
  void drawIndexed(uint[] indices, int baseVertex, uint[] instances) {
    assert(indices.length);
    assert(baseVertex >= 0);
    assert(instances.length);
    // TODO: void wgpuRenderPassEncoderDrawIndexed(WGPURenderPassEncoder renderPassEncoder, uint32_t indexCount, uint32_t instanceCount, uint32_t firstIndex, int32_t baseVertex, uint32_t firstInstance);
  }

  // TODO: void wgpuRenderPassEncoderDrawIndexedIndirect(WGPURenderPassEncoder renderPassEncoder, WGPUBuffer indirectBuffer, uint64_t indirectOffset);
  // TODO: void wgpuRenderPassEncoderDrawIndirect(WGPURenderPassEncoder renderPassEncoder, WGPUBuffer indirectBuffer, uint64_t indirectOffset);
}

/// A handle to a compute pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ComputePipeline.html">wgpu::ComputePipeline</a>
struct ComputePipeline {
  /// Handle identifier.
  WGPUComputePipeline id;
  /// Describes this `ComputePipeline`.
  ComputePipelineDescriptor descriptor;

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuComputePipelineDrop(id);
    id = null;
  }

  /// Get the bind group layout at the given `index`.
  // TODO: BindGroupLayout bindGroupLayout(uint index) {}
}

/// An in-progress recording of a compute pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ComputePass.html">wgpu::ComputePass</a>
struct ComputePass {
  package WGPUComputePassEncoder instance;
  /// Describes this `ComputePass`.
  ComputePassDescriptor descriptor;

  /// Sets the active bind group for a given bind group index.
  ///
  /// If the bind group have dynamic offsets, provide them in order of their declaration. These offsets must be aligned to `BIND_BUFFER_ALIGNMENT`.
  void setBindGroup(const uint index, BindGroup bindGroup, const uint[] offsets) {
    wgpuComputePassEncoderSetBindGroup(instance, index, bindGroup.id, offsets.length.to!uint, offsets.ptr);
  }

  /// Sets the active compute pipeline.
  void setPipeline(ComputePipeline pipeline) {
    wgpuComputePassEncoderSetPipeline(instance, pipeline.id);
  }

  ///Dispatches compute work operations.
  ///
  /// x, y and z denote the number of work groups to dispatch in each dimension.
  void dispatch(const uint x, const uint y, const uint z) {
    wgpuComputePassEncoderDispatch(instance, x, y, z);
  }

  // TODO: void wgpuComputePassEncoderDispatchIndirect(WGPUComputePassEncoder computePassEncoder, WGPUBuffer indirectBuffer, uint64_t indirectOffset);

  // TODO: void wgpuComputePassEncoderBeginPipelineStatisticsQuery(WGPUComputePassEncoder computePassEncoder, WGPUQuerySet querySet, uint32_t queryIndex);
  // TODO: void wgpuComputePassEncoderEndPipelineStatisticsQuery(WGPUComputePassEncoder computePassEncoder);
  // TODO: void wgpuComputePassEncoderEndPass(WGPUComputePassEncoder computePassEncoder);
  // TODO: void wgpuComputePassEncoderInsertDebugMarker(WGPUComputePassEncoder computePassEncoder, char const * markerLabel);
  // TODO: void wgpuComputePassEncoderPopDebugGroup(WGPUComputePassEncoder computePassEncoder);
  // TODO: void wgpuComputePassEncoderPushDebugGroup(WGPUComputePassEncoder computePassEncoder, char const * groupLabel);
  // See_Also: `QUERY_SIZE`
  // TODO: void wgpuComputePassEncoderWriteTimestamp(WGPUComputePassEncoder computePassEncoder, WGPUQuerySet querySet, uint32_t queryIndex);
}
