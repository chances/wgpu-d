/// An idiomatic D wrapper for <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a>.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020-2022 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.api;

import core.stdc.config : c_ulong;
import std.conv : asOriginalType, to;
import std.string : fromStringz, toStringz;
import std.typecons : Flag, No, Yes;

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
/// See_Also: `Texture.paddedBytesPerRow`: Size of one row of a texture's pixels/blocks, in bytes. Aligned to `COPY_BYTES_PER_ROW_ALIGNMENT`.
static const uint COPY_BYTES_PER_ROW_ALIGNMENT = 256;

/// Size of a single occlusion/timestamp query, when copied into a buffer, in bytes.
static const uint QUERY_SIZE = 8;

// TODO: Does the library need these?
/// Maximum anisotropy.
static const uint MAX_ANISOTROPY = 16;
/// Maximum number of color targets.
static const uint MAX_COLOR_TARGETS = 4;
/// Maximum amount of mipmap levels.
static const uint MAX_MIP_LEVELS = 16;
/// Maximum number of vertex buffers.
static const uint MAX_VERTEX_BUFFERS = 16;

// Opaque Pointers
// TODO: Implement a wrapper around `WGPUQuerySet`
alias QuerySet = WGPUQuerySet;

alias ChainedStruct = WGPUChainedStruct;
alias ChainedStructOut = WGPUChainedStructOut;
alias AdapterProperties = WGPUAdapterProperties;
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BindGroupEntry.html">wgpu::BindGroupEntry</a>
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
/// Origin of a copy to/from a texture.
alias Origin3d = WGPUOrigin3D;
/// Describes a `PipelineLayout`.
alias PipelineLayoutDescriptor = WGPUPipelineLayoutDescriptor;
alias PrimitiveDepthClampingState = WGPUPrimitiveDepthClampingState;
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
/// See_Also:
/// $(UL
///   $(LI `Texture.dataLayout` )
///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a> )
/// )
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
// TODO: View of a buffer which can be used to copy to/from a texture.
/// View of a texture which can be used to copy to/from a buffer.
alias ImageCopyBuffer = WGPUImageCopyBuffer;
/// View of a texture which can be used to copy to/from a texture.
alias ImageCopyTexture = WGPUImageCopyTexture;
/// Describes a color attachment to a `RenderPass`.
alias RenderPassColorAttachment = WGPURenderPassColorAttachment;
/// Describes a `Texture`.
alias TextureDescriptor = WGPUTextureDescriptor;
/// Describes how the vertex buffer is interpreted.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.VertexBufferLayout.html">wgpu::VertexBufferLayout</a>
alias VertexBufferLayout = WGPUVertexBufferLayout;
/// Describes a `BindGroupLayout`.
alias BindGroupLayoutDescriptor = WGPUBindGroupLayoutDescriptor;
/// Describes a `ComputePipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ComputePipelineDescriptor.html">wgpu::ComputePipelineDescriptor</a>
alias ComputePipelineDescriptor = WGPUComputePipelineDescriptor;
/// Describes the attachments of a `RenderPass`.
alias RenderPassDescriptor = WGPURenderPassDescriptor;
/// Describes a `RenderPipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.RenderPipelineDescriptor.html">wgpu::RenderPipelineDescriptor</a>
alias RenderPipelineDescriptor = WGPURenderPipelineDescriptor;
alias AdapterExtras = WGPUAdapterExtras;

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
    // Fix case of "BC", "RG", "CW", "CCW", "RGB", "RGBA", and "BGRA" prefixes
    if (idiomaticMember.length > 4) {
      if (idiomaticMember[0..4] == "bGRA") idiomaticMember = "bgra" ~ idiomaticMember[4..$];
      else if (idiomaticMember[0..4] == "rGBA") idiomaticMember = "rgba" ~ idiomaticMember[4..$];
      else if (idiomaticMember[0..3] == "rGB") idiomaticMember = "rgb" ~ idiomaticMember[3..$];
      else if (idiomaticMember[0..2] == "rG") idiomaticMember = "rg" ~ idiomaticMember[2..$];
      else if (idiomaticMember[0..2] == "bC") idiomaticMember = "bc" ~ idiomaticMember[2..$];
    } else if (idiomaticMember == "cCW") {
      idiomaticMember = "ccw";
    } else if (idiomaticMember == "cW") {
      idiomaticMember = "cw";
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
/// Specific type of a sample in a texture binding.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.TextureSampleType.html">wgpu::TextureSampleType</a>
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
/// Mask which enables/disables writes to different color/alpha channel.
/// Disabled color channels will not be written to.
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

/// Constant blending modes usable when constructing a `ColorTargetState`'s `BlendState`.
/// See_Also:
/// $(UL
///   $(LI `Texture.asRenderTarget` )
///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BlendState.html">wgpu::BlendState</a> )
///   $(LI See the OpenGL or Vulkan spec for more information. )
/// )
enum BlendMode : BlendState {
  /// Performs `(1 * src) + (0 * dst)` for both color and alpha components.
  /// See_Also: `BlendMode.replace`
  srcOneDstZeroAdd = BlendState(
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.zero),
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.zero)
  ),
  /// Blend mode that does no color blending, just overwrites the output with the contents of the shader.
  /// See_Also: `BlendMode.srcOneDstZeroAdd`
  replace = BlendState(
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.zero), // Replace, (1 * src) + (0 * dst)
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.zero), // Replace, (1 * src) + (0 * dst)
  ),
  /// Blend mode that does standard alpha blending with non-premultiplied alpha.
  alphaBlending = BlendState(
    BlendComponent(BlendOperation.add, BlendFactor.srcAlpha, BlendFactor.oneMinusSrcAlpha),
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.oneMinusSrcAlpha) // Over, (1 * src) + ((1 - src_alpha) * dst)
  ),
  /// Blend mode that does standard alpha blending with premultiplied alpha.
  premultipliedAlphaBlending = BlendState(
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.oneMinusSrcAlpha), // Over, (1 * src) + ((1 - src_alpha) * dst)
    BlendComponent(BlendOperation.add, BlendFactor.one, BlendFactor.oneMinusSrcAlpha), // Over, (1 * src) + ((1 - src_alpha) * dst)
  ),
}

// Structures

/// Describes the multi-sampling state of a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.MultisampleState.html">wgpu::MultisampleState</a>
struct MultisampleState {
  WGPUMultisampleState state;
  alias state this;

  ///
  this(
    uint sampleCount, uint mask = ~0, Flag!"alphaToCoverageEnabled" alphaToCoverageEnabled = No.alphaToCoverageEnabled
  ) {
    state = WGPUMultisampleState(null, sampleCount, mask, alphaToCoverageEnabled);
  }

  ///
  static MultisampleState singleSample() {
    return MultisampleState(1, ~0, No.alphaToCoverageEnabled);
  }
}
/// Describes the state of primitive assembly and rasterization in a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.PrimitiveState.html">wgpu::PrimitiveState</a>
struct PrimitiveState {
  WGPUPrimitiveState state;
  alias state this;

  this(WGPUPrimitiveTopology topology, WGPUIndexFormat indexFormat, WGPUFrontFace frontFace, WGPUCullMode cullMode) {
    state = WGPUPrimitiveState(null, topology, indexFormat, frontFace, cullMode);
  }
}
/// Describes the depth/stencil state in a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.DepthStencilState.html">wgpu::DepthStencilState</a>
struct DepthStencilState {
  WGPUDepthStencilState state;
  alias state this;

  ///
  this(
    WGPUTextureFormat format,
    Flag!"depthWriteEnabled" depthWriteEnabled, WGPUCompareFunction depthCompare,
    StencilFaceState stencilFront, StencilFaceState stencilBack,
    uint stencilReadMask, uint stencilWriteMask,
    int depthBias, float depthBiasSlopeScale, float depthBiasClamp,
  ) {
    state = WGPUDepthStencilState(
      null, format,
      depthWriteEnabled, depthCompare,
      stencilFront, stencilBack,
      stencilReadMask, stencilWriteMask,
      depthBias, depthBiasSlopeScale, depthBiasClamp
    );
  }
}
/// Describes the color state of a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ColorTargetState.html">wgpu::ColorTargetState</a>
class ColorTargetState {
  /// The texture format of the image that this target's associated pipeline will render to.
  /// Must match the the format of the corresponding color attachment in `CommandEncoder.beginRenderPass`.
  TextureFormat format;
  /// Blending used when compositing colors in this target's associated pipeline.
  BlendState blend;
  /// Mask which enables/disables writes to different color/alpha channel.
  uint writeMask;

  /// Params:
  /// format = The texture format of the image that this target's associated pipeline will render to.
  /// blend = Blending used when rendering fragments in this target's `RenderPipeline`.
  /// writeMask = Mask which enables/disables writes to different color/alpha channel. See `ColorWriteMask`.
  /// Returns: A result suitable for use as a pipeline's fragment stage. See `RenderPipeline.fragmentState`.
  /// See_Also: `RenderPipeline`
  this(TextureFormat format, BlendState blend, uint writeMask = ColorWriteMask.all) {
    this.format = format;
    this.blend = blend;
    this.writeMask = writeMask;
  }

  package auto state() @trusted @property const {
    return WGPUColorTargetState(null, cast(WGPUTextureFormat) format, &blend, writeMask);
  }
}
/// Describes the vertex process in a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.VertexState.html">wgpu::VertexState</a>
struct VertexState {
  WGPUVertexState state;
  alias state this;

  /// Params:
  /// shader = The compiled shader module for this stage.
  /// entryPoint = The name of the entry point in the compiled shader. There must be a function that returns void with this name in the shader.
  /// buffers = The format of any vertex buffers used with this pipeline.
  this(ShaderModule shader, string entryPoint, VertexBufferLayout[] buffers = []) {
    this(shader, entryPoint, [], buffers);
  }
  /// Params:
  /// shader = The compiled shader module for this stage.
  /// entryPoint = The name of the entry point in the compiled shader. There must be a function that returns void with this name in the shader.
  /// constants = The push constants provided to the compiled shader for this stage.
  /// buffers = The format of any vertex buffers used with this pipeline.
  this(ShaderModule shader, string entryPoint, ConstantEntry[] constants, VertexBufferLayout[] buffers = []) {
    if (constants.length == 0 && buffers.length == 0)
      state = WGPUVertexState(null, shader.id, entryPoint.toStringz, 0, null, 0, null);
    else if (buffers.length == 0)
      state = WGPUVertexState(null, shader.id, entryPoint.toStringz, constants.length.to!uint, constants.ptr, 0, null);
    else
      state = WGPUVertexState(null, shader.id, entryPoint.toStringz, 0, null, buffers.length.to!uint, buffers.ptr);
  }
}
/// Describes the fragment process in a render pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.FragmentState.html">wgpu::FragmentState</a>
class FragmentState {
  /// The compiled shader module for this stage.
  ShaderModule shader;
  /// The name of the entry point in the compiled shader.
  /// Remarks: There must be a function that returns `void` with this name in the shader.
  string entryPoint;
  /// The push constants provided to the compiled shader for this stage.
  ConstantEntry[] constants;
  /// The color state of the render targets.
  const ColorTargetState[] renderTargets;
  package const WGPUColorTargetState[] targets;

  /// Params:
  /// shader = The compiled shader module for this stage.
  /// entryPoint = The name of the entry point in the compiled shader. There must be a function that returns void with this name in the shader.
  /// renderTargets = The color state of the render targets.
  this(ShaderModule shader, string entryPoint, ColorTargetState[] renderTargets) {
    this(shader, entryPoint, [], renderTargets);
  }
  /// Params:
  /// shader = The compiled shader module for this stage.
  /// entryPoint = The name of the entry point in the compiled shader. There must be a function that returns void with this name in the shader.
  /// constants = The push constants provided to the compiled shader for this stage.
  /// renderTargets = The color state of the render targets.
  this(ShaderModule shader, string entryPoint, ConstantEntry[] constants, ColorTargetState[] renderTargets) {
    import std.algorithm : map;
    import std.array : array;

    assert(shader.id !is null, "Fragment shader is not initialized");
    assert(entryPoint !is null);

    this.shader = shader;
    this.entryPoint = entryPoint;
    this.constants = constants;
    this.renderTargets = renderTargets;
    this.targets = renderTargets.map!(t => t.state).array;
  }

  package const(WGPUFragmentState) state() @trusted @property const {
    return WGPUFragmentState(
      null, cast(WGPUShaderModule) shader.id, entryPoint.toStringz,
      constants.length.to!uint, constants.length == 0 ? null : constants.ptr,
      targets.length.to!uint, targets.ptr
    );
  }
}

extern (C) private void wgpu_request_adapter_callback(
  WGPURequestAdapterStatus status, WGPUAdapter id, const char* message, void* data
) {
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
  assert(status == RequestDeviceStatus.success.asOriginalType);
  assert(data !is null);
  auto device = cast(Device) data;
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
  static Adapter requestAdapter(
    PowerPreference powerPreference = PowerPreference.highPerformance,
    Flag!"forceFallbackAdapter" forceFallbackAdapter = No.forceFallbackAdapter
  ) {
    return requestAdapter(
      RequestAdapterOptions(null, /* compatibleSurface: */ null, powerPreference, forceFallbackAdapter)
    );
  }
  /// ditto
  static Adapter requestAdapter(
    Surface compatibleSurface, PowerPreference powerPreference = PowerPreference.highPerformance,
    Flag!"forceFallbackAdapter" forceFallbackAdapter = No.forceFallbackAdapter
  ) {
    assert(compatibleSurface.id !is null, "Given compatible surface is not valid");
    return requestAdapter(RequestAdapterOptions(null, compatibleSurface.id, powerPreference, forceFallbackAdapter));
  }
  /// ditto
  static Adapter requestAdapter(RequestAdapterOptions options) @trusted {
    Adapter adapter;
    wgpuInstanceRequestAdapter(null, &options, &wgpu_request_adapter_callback, &adapter);
    assert(adapter.ready);
    return adapter;
  }
}

/// A handle to a physical graphics and/or compute device.
///
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Adapter.html">wgpu::Adapter</a>
struct Adapter {
  import std.traits : fullyQualifiedName;

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
  /// Limits must be explicitly requested in `Adapter.requestDevice` to control the values you are allowed to use.
  Limits limits() {
    assert(ready);
    WGPUSupportedLimits limits;
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
  Device requestDevice(const Limits limits, string label = fullyQualifiedName!Device) {
    return requestDevice(limits, null, label);
  }
  /// Requests a connection to a physical device, creating a logical device.
  ///
  /// Params:
  /// limits = Set of required limits the device must supports.
  /// tracePath = Optional path on the target file system at which to write a GPU debug trace.
  /// label = Optional debug label for the `Device`.
  Device requestDevice(const Limits limits, string tracePath = null, string label = fullyQualifiedName!Device) {
    assert(ready);
    auto device = new Device(label);
    const WGPUDeviceExtras extras = {
      chain: WGPUChainedStruct(null, cast(WGPUSType) WGPUNativeSType.WGPUSType_DeviceExtras),
      label: device.label.toStringz,
      tracePath: tracePath is null ? null : tracePath.toStringz
    };
    WGPURequiredLimits requiredLimits = { limits: limits };
    WGPUDeviceDescriptor desc = {
      nextInChain: cast(const(WGPUChainedStruct)*) &extras,
      requiredLimits: &requiredLimits
    };
    wgpuAdapterRequestDevice(id, &desc, &wgpu_request_device_callback, cast(void*) device);
    return device;
  }
}

/// An open connection to a graphics and/or compute device.
///
/// The `Device` is the responsible for the creation of most rendering and compute resources, as well as exposing `Queue` objects.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Device.html">wgpu::Device</a>
class Device {
  package WGPUDevice id;
  /// Label for this Device.
  string label;

  package this(string label) {
    this.label = label;
    // TODO: Set the device label once the device has been retreived.
  }

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
  ///
  /// Shader modules are used to define programmable stages of a pipeline.
  ShaderModule createShaderModule(const byte[] spv) @trusted {
    // TODO: assert SPIR-V magic number is at the beginning of the stream
    // TODO: assert input is not longer than `size_t.max`
    ShaderModuleSPIRVDescriptor spirv = {
      chain: WGPUChainedStruct(null, cast(WGPUSType) SType.shaderModuleSPIRVDescriptor),
      codeSize: spv.length.to!uint,
      code: spv.to!(uint[]).ptr,
    };
    auto desc = ShaderModuleDescriptor(cast(const(WGPUChainedStruct)*) &spirv);
    return ShaderModule(wgpuDeviceCreateShaderModule(id, &desc));
  }

  /// Creates a shader module from WGSL source code.
  ///
  /// Shader modules are used to define programmable stages of a pipeline.
  ShaderModule createShaderModule(string wgsl) @trusted {
    ShaderModuleWGSLDescriptor wgslDesc = {
      chain: WGPUChainedStruct(null, cast(WGPUSType) SType.shaderModuleWGSLDescriptor),
      source: wgsl.toStringz,
    };
    auto desc = ShaderModuleDescriptor(cast(const(WGPUChainedStruct)*) &wgslDesc);
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

  /// Creates a bind group layout.
  BindGroupLayout createBindGroupLayout(BindGroupLayoutEntry[] entries, string label = null) {
    // See https://docs.rs/wgpu/0.10.2/wgpu/struct.BindGroupLayoutDescriptor.html
    return createBindGroupLayout(BindGroupLayoutDescriptor(
      null, label is null ? null : label.toStringz,
      entries.length.to!uint, entries.ptr,
    ));
  }
  /// ditto
  BindGroupLayout createBindGroupLayout(const BindGroupLayoutDescriptor descriptor) {
    return BindGroupLayout(wgpuDeviceCreateBindGroupLayout(id, &descriptor), descriptor);
  }

  /// Creates a new bind group.
  BindGroup createBindGroup(BindGroupLayout layout, BindGroupEntry[] entries, string label = null) {
    assert(entries.length);
    return createBindGroup(
      BindGroupDescriptor(null, label is null ? null : label.toStringz, layout.id, entries.length.to!uint, entries.ptr)
    );
  }
  /// ditto
  BindGroup createBindGroup(BindGroupDescriptor descriptor) {
    return BindGroup(wgpuDeviceCreateBindGroup(id, cast(BindGroupDescriptor*) &descriptor), descriptor);
  }

  /// Creates an empty `PipelineLayout` that has no bindings.
  PipelineLayout emptyPipelineLayout(string label = null) {
    return createPipelineLayout([], label);
  }

  /// Creates a bind group `PipelineLayout`.
  PipelineLayout createPipelineLayout(const BindGroupLayout[] bindGroups, string label = null) {
    import std.algorithm : map;
    import std.array : array;

    PipelineLayoutDescriptor desc = {
      label: label is null ? null : label.toStringz,
      bindGroupLayoutCount: bindGroups.length.to!uint,
      bindGroupLayouts: bindGroups.length == 0 ? null : bindGroups.map!(b => b.id).array.ptr,
    };
    return createPipelineLayout(desc);
  }
  /// ditto
  PipelineLayout createPipelineLayout(const PipelineLayoutDescriptor descriptor) {
    return PipelineLayout(wgpuDeviceCreatePipelineLayout(id, &descriptor), descriptor);
  }

  /// Creates a render pipeline.
  ///
  /// The depth and stencil buffers are disabled in the created pipeline.
  RenderPipeline createRenderPipeline(
    PipelineLayout layout,
    VertexState vertexState, PrimitiveState primitiveState,
    MultisampleState multisampleState, FragmentState fragmentState,
    string label = null,
  ) {
    auto fragment = fragmentState.state;
    auto descriptor = RenderPipelineDescriptor(
      null,
      label is null ? null : label.toStringz,
      layout.id, vertexState.state, primitiveState.state,
      null, multisampleState.state, &fragment,
    );
    return new RenderPipeline(this, descriptor, fragmentState);
  }
  /// Creates a render pipeline.
  RenderPipeline createRenderPipeline(
    PipelineLayout layout,
    VertexState vertexState, PrimitiveState primitiveState,
    const DepthStencilState depthStencilState,
    MultisampleState multisampleState, FragmentState fragmentState,
    string label = null,
  ) {
    auto fragment = fragmentState.state;
    auto descriptor = RenderPipelineDescriptor(
      null,
      label is null ? null : label.toStringz,
      layout.id, vertexState.state, primitiveState.state,
      &depthStencilState.state, multisampleState.state,
      &fragment,
    );
    return new RenderPipeline(this, descriptor, fragmentState);
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
    const string label = null
  ) {
    return createBuffer(BufferDescriptor(null, label is null ? null : label.toStringz, usage, size, mappedAtCreation));
  }
  /// Creates a new buffer.
  Buffer createBuffer(const BufferDescriptor descriptor) {
    return new Buffer(this, descriptor);
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
    const TextureFormat format, const TextureUsage usage,
    const TextureDimension dimension = TextureDimension._2D,
    uint mipLevelCount = 1,
    uint sampleCount = 1,
    uint depthOrArrayLayers = 1,
    const string label = null
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
    const Extent3d extent, const TextureFormat format, const TextureUsage usage,
    const TextureDimension dimension = TextureDimension._2D,
    uint mipLevelCount = 1,
    uint sampleCount = 1,
    const string label = null
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
    return new Texture(this, descriptor);
  }

  /// Creates a new `Sampler`.
  ///
  /// Params:
  /// addressMode = How to deal with out of bounds accesses.
  /// magFilter = How to filter the texture when it needs to be magnified/made larger.
  /// minFilter = How to filter the texture when it needs to be minified/made smaller.
  /// mipmapFilter = How to filter between mip map levels.
  Sampler createSampler(
    AddressMode addressMode, FilterMode magFilter, FilterMode minFilter, FilterMode mipmapFilter = FilterMode.nearest
  ) {
    SamplerDescriptor desc = {
      addressModeU: addressMode,
      addressModeV: addressMode,
      addressModeW: addressMode,
      magFilter: magFilter,
      minFilter: minFilter,
      mipmapFilter: mipmapFilter,
    };
    return createSampler(desc);
  }
  /// Creates a new `Sampler`.
  ///
  /// Params:
  /// descriptor = Specifies the behavior of the sampler.
  Sampler createSampler(const SamplerDescriptor descriptor) {
    return Sampler(wgpuDeviceCreateSampler(id, &descriptor), descriptor);
  }

  /// Create a new `SwapChain` which targets `surface`.
  SwapChain createSwapChain(
    const Surface surface, uint width, uint height,
    const TextureFormat format, const TextureUsage usage,
    const PresentMode presentMode, const string label = null
  ) {
    return createSwapChain(surface, SwapChainDescriptor(
      null, label is null ? null : label.toStringz,
      usage, format, width, height, presentMode
    ));
  }
  /// ditto
  SwapChain createSwapChain(const Surface surface, const SwapChainDescriptor descriptor) {
    return new SwapChain(this, surface, descriptor);
  }
}

/// A handle to a presentable surface.
///
/// A Surface represents a platform-specific surface (e.g. a window) to which rendered images may be presented.
///
/// A Surface may be created with `Surface.fromMetalLayer`, `Surface.fromWindowsHwnd`, or `Surface.fromXlib`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Surface.html">wgpu::Surface</a>
struct Surface {
  /// Handle identifier.
  WGPUSurface id;

  version (OSX) {
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(void* layer, string label = null) {
      auto metalLayer = SurfaceDescriptorFromMetalLayer(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromMetalLayer.asOriginalType),
        layer
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &metalLayer, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(null, &desc));
    }
    /// ditto
    static Surface fromMetalLayer(Instance instance, void* layer, string label = null) {
      auto metalLayer = SurfaceDescriptorFromMetalLayer(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromMetalLayer.asOriginalType),
        layer
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &metalLayer, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  } else version (D_Ddoc) {
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(void* layer, string label = null);
    /// ditto
    static Surface fromMetalLayer(Instance instance, void* layer, string label = null);
  }
  version (Windows) {
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(void* _hinstance, void* hwnd, string label = null) {
      auto windowsHwnd = SurfaceDescriptorFromWindowsHwnd(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromWindowsHwnd.asOriginalType),
        _hinstance, hwnd
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &windowsHwnd, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(null, &desc));
    }
    /// ditto
    static Surface fromWindowsHwnd(Instance instance, void* _hinstance, void* hwnd, string label = null) {
      auto windowsHwnd = SurfaceDescriptorFromWindowsHwnd(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromWindowsHwnd.asOriginalType),
        _hinstance, hwnd
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &windowsHwnd, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  } else version (D_Ddoc) {
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(void* _hinstance, void* hwnd, string label = null);
    static Surface fromWindowsHwnd(Instance instance, void* _hinstance, void* hwnd, string label = null);
  }
  version (linux) {
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(void* display, uint window, string label = null) {
      auto xlib = SurfaceDescriptorFromXlib(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromXlib.asOriginalType),
        display, window
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &xlib, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(null, &desc));
    }
    /// ditto
    static Surface fromXlib(Instance instance, void* display, uint window, string label = null) {
      auto xlib = SurfaceDescriptorFromXlib(
        ChainedStruct(null, cast(WGPUSType) SType.surfaceDescriptorFromXlib.asOriginalType),
        display, window
      );
      auto desc = SurfaceDescriptor(cast(ChainedStruct*) &xlib, label is null ? null : label.toStringz);
      return Surface(wgpuInstanceCreateSurface(instance.id, &desc));
    }
  } else version (D_Ddoc) {
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(void* display, uint window, string label = null);
    static Surface fromXlib(Instance instance, void* display, uint window, string label = null);
  }
  // TODO: Support Wayland with a `linux-wayland` version config once upstream wgpu-native supports it

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
class SwapChain {
  package WGPUSwapChain id;
  /// `Surface` this swap chain renders to.
  const Surface surface;
  /// Describes this `SwapChain.`
  const SwapChainDescriptor descriptor;
  /// Optional, human-readable debug label for this swap chain.
  const string label;

  package this(Device device, const Surface surface, const SwapChainDescriptor descriptor) {
    id = wgpuDeviceCreateSwapChain(device.id, cast(WGPUSurface) surface.id, &descriptor);
    this.surface = surface;
    this.descriptor = descriptor;
    this.label = descriptor.label is null ? null : descriptor.label.fromStringz.to!string;
  }

  /// Returns the next texture to be presented by the swapchain for drawing.
  TextureView getNextTexture() {
    TextureViewDescriptor viewDesc = {
      label: descriptor.label,
      format: descriptor.format,
      dimension: TextureViewDimension.undefined,
      aspect: TextureAspect.all,
    };
    return TextureView(wgpuSwapChainGetCurrentTextureView(id), viewDesc, No.multisampled);
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
  auto buffer = cast(Buffer) data;
  assert(buffer.id !is null);

  buffer.status = status.to!int.to!BufferMapAsyncStatus;
}

/// A handle to a GPU-accessible buffer.
///
/// Created with `Device.createBuffer`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Buffer.html">wgpu::Buffer</a>
class Buffer {
  package WGPUBuffer id;
  /// Describes this `Buffer`.
  const BufferDescriptor descriptor;
  /// Optional, human-readable debug label.
  const string label;
  /// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  BufferMapAsyncStatus status = BufferMapAsyncStatus.unknown;

  package this(Device device, const BufferDescriptor descriptor) {
    id = wgpuDeviceCreateBuffer(device.id, &descriptor);
    this.descriptor = descriptor;
    label = descriptor.label is null ? null : descriptor.label.fromStringz.to!string;
  }

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuBufferDestroy(id);
    id = null;
  }

  /// Get the sliced `Buffer` data requested by either `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  ubyte[] getMappedRange(size_t start, size_t size) @trusted {
    assert(start + size <= descriptor.size);
    assert(status == BufferMapAsyncStatus.success);

    auto data = wgpuBufferGetMappedRange(id, start, size);
    return cast(ubyte[]) data[0 .. size];
  }

  /// Map the buffer for reading asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapReadAsync(size_t start, size_t size) @trusted {
    assert(start + size <= descriptor.size);
    wgpuBufferMapAsync(id, MapMode.read, start, size, &wgpuBufferMapCallback, cast(void*) this);
  }

  /// Map the buffer for writing asynchronously.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferSlice.html#method.map_async">wgpu::BufferSlice::map_async</a>
  void mapWriteAsync(size_t start, size_t size) @trusted {
    assert(start + size <= descriptor.size);
    wgpuBufferMapAsync(id, MapMode.write, start, size, &wgpuBufferMapCallback, cast(void*) this);
  }

  /// Flushes any pending write operations and unmaps the buffer from host memory.
  void unmap() {
    wgpuBufferUnmap(id);
  }
}

/// A handle to a texture on the GPU.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Texture.html">wgpu::Texture</a>
// TODO: Expand docs akin to https://veldrid.dev/articles/textures.html
class Texture {
  package WGPUTexture id;
  /// Describes this texture.
  const TextureDescriptor descriptor;
  /// Optional, human-readable debug label for this texture.
  const string label;

  package this(Device device, TextureDescriptor descriptor) {
    id = wgpuDeviceCreateTexture(device.id, &descriptor);
    this.descriptor = descriptor;
    this.label = descriptor.label is null ? null : descriptor.label.fromStringz.to!string;
  }

  /// Size and depth/layer count of this texture.
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

  /// Bytes per “block” of this texture.
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

  /// See_Also:
  /// $(UL
  ///   $(LI `Texture.bytesPerBlock` )
  ///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a> )
  /// )
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

  /// Size of one row of a texture's pixels/blocks, in bytes.
  /// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ImageDataLayout.html">wgpu::ImageDataLayout</a>
  uint bytesPerRow() @property const {
    return descriptor.size.width * bytesPerBlock;
  }

  /// Size of one row of a texture's pixels/blocks, in bytes. Aligned to `COPY_BYTES_PER_ROW_ALIGNMENT`.
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

  /// Make an `ImageCopyTexture` representing the whole texture.
  ImageCopyTexture asImageCopy() @property const {
    return ImageCopyTexture(
      null,
      cast(WGPUTexture) id,
      /* Mip level */ 0,
      Origin3d(0, 0, 0),
      TextureAspect.all
    );
  }

  /// Make a `TextureDataLayout` given this texture's `size` and `TextureFormat`.
  /// Returns: A result suitable for use in Buffer-Texture copies, e.g. `CommandEncoder.copyTextureToBuffer`.
  TextureDataLayout dataLayout() @property const {
    return TextureDataLayout(
      null,
      0, // Offset
      paddedBytesPerRow,
      size.depthOrArrayLayers == 1 ? 0 : rowsPerImage,
    );
  }

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuTextureDestroy(id);
    id = null;
  }

  /// Creates a view of this texture.
  TextureView createView(const TextureViewDescriptor descriptor) inout @trusted {
    assert(id !is null);
    return TextureView(
      wgpuTextureCreateView(cast(WGPUTexture) id, &descriptor),
      descriptor,
      this.descriptor.sampleCount > 1 ? Yes.multisampled : No.multisampled
    );
  }

  /// Creates a default view of this whole texture.
  TextureView defaultView() @property const {
    import wgpu.utils : viewDimension;

    const TextureDimension dimension = descriptor.dimension.asOriginalType.to!TextureDimension;
    TextureViewDescriptor desc = {
      label: descriptor.label,
      format: descriptor.format,
      dimension: dimension.viewDimension(size.depthOrArrayLayers),
      aspect: TextureAspect.all,
    };
    return createView(desc);
  }

  /// Make a `ColorTargetState` given this texture's `TextureFormat` and a constant blending mode.
  ///
  /// Params:
  /// blend = A constant blending mode.
  /// writeMask = Mask which enables/disables writes to different color/alpha channel. See `ColorWriteMask`.
  /// Returns: A result suitable for use as a pipeline's fragment stage. See `RenderPipeline.fragmentState`.
  ColorTargetState asRenderTarget(const BlendMode blend, uint writeMask = ColorWriteMask.all) const {
    return asRenderTarget(blend.asOriginalType, writeMask);
  }
  /// Make a `ColorTargetState` given this texture's `TextureFormat` and a custom blending mode.
  ///
  /// Params:
  /// blend = A custom blending mode.
  /// writeMask = Mask which enables/disables writes to different color/alpha channel. See `ColorWriteMask`.
  /// Returns: A result suitable for use as a pipeline's fragment stage. See `RenderPipeline.fragmentState`.
  ColorTargetState asRenderTarget(const BlendState blend, uint writeMask = ColorWriteMask.all) const {
    return new ColorTargetState(descriptor.format.asOriginalType.to!TextureFormat, blend, writeMask);
  }

  /// Creates a multisample state given this texture's `TextureDescriptor.sampleCount`.
  MultisampleState multisampleState(
    uint mask = ~0, Flag!"alphaToCoverageEnabled" alphaToCoverageEnabled = No.alphaToCoverageEnabled
  ) const {
    return MultisampleState(descriptor.sampleCount, mask, alphaToCoverageEnabled);
  }
}

/// A handle to a texture view.
///
/// A `TextureView` object describes a texture and associated metadata needed by a `RenderPipeline` or `BindGroup`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.TextureView.html">wgpu::TextureView</a>
struct TextureView {
  package WGPUTextureView id;
  /// Describes this texture view.
  const TextureViewDescriptor descriptor;
  /// Whether this texture view is multisampled.
  const Flag!"multisampled" multisampled;

  /// Release the handle to this texture view.
  void destroy() {
    if (id !is null) wgpuTextureViewDrop(id);
    id = null;
  }

  /// Creates a texture-sampler pair of consecutive bindings, starting at `location`.
  BindGroupLayoutEntry[] textureSampler(
    uint location, ShaderStage visibility,
    Flag!"filtering" filtering = Yes.filtering
  ) const {
    auto texture = BindGroupLayoutEntry(null, location, visibility);
    texture.texture = TextureBindingLayout(
      null, filtering ? TextureSampleType.float_ : TextureSampleType.unfilterableFloat,
      descriptor.dimension,
      multisampled
    );
    auto sampler = BindGroupLayoutEntry(null, location + 1, visibility);
    sampler.sampler = SamplerBindingLayout(
      null, filtering ? SamplerBindingType.filtering : SamplerBindingType.nonFiltering
    );
    return [texture, sampler];
  }

  /// Creates a texture view binding.
  BindGroupEntry binding(uint location) {
    BindGroupEntry binding = { binding: location, textureView: id };
    return binding;
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
  package WGPUSampler id;
  /// Describes this `Sampler`.
  SamplerDescriptor descriptor;

  /// Creates a sampler binding.
  BindGroupEntry binding(uint location) {
    BindGroupEntry binding = { binding: location, sampler: id };
    return binding;
  }
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

/// A handle to a compiled shader module on the GPU.
///
/// A `ShaderModule` can be created by passing valid SPIR-V source code to `Device.createShaderModule`.
/// Remarks: Shader modules are used to define programmable stages of a pipeline.
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

  /// Copy data from a `Buffer` to a `Texture`.
  ///
  /// Remarks: Copies the whole extent of the `destination` texture.
  void copyBufferToTexture(const Buffer source, const Texture destination) {
    copyBufferToTexture(
      ImageCopyBuffer(null, destination.dataLayout, cast(WGPUBuffer) source.id),
      destination.asImageCopy,
      destination.descriptor.size,
    );
  }
  /// Copy data from a buffer to a texture.
  void copyBufferToTexture(const ImageCopyBuffer source, const ImageCopyTexture destination, const Extent3d copySize) {
    wgpuCommandEncoderCopyBufferToTexture(id, &source, &destination, &copySize);
  }

  /// Copy data from a `Texture` to a `Buffer`.
  ///
  /// Remarks: Copies the whole extent of the `source` texture.
  void copyTextureToBuffer(const Texture source, const Buffer destination) {
    copyTextureToBuffer(source, destination, source.descriptor.size);
  }
  /// Copy data from a `Texture` to a `Buffer`.
  void copyTextureToBuffer(const Texture source, const Buffer destination, const Extent3d copySize) {
    copyTextureToBuffer(
      source.asImageCopy,
      ImageCopyBuffer(null, source.dataLayout, cast(WGPUBuffer) destination.id),
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
  /// Describes this binding group.
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
class RenderPipeline {
  package WGPURenderPipeline id;
  /// Describes this render pipeline.
  RenderPipelineDescriptor descriptor;
  /// Describes the fragment process in this render pipeline.
  const FragmentState fragmentState;

  package this(Device device, RenderPipelineDescriptor descriptor, const FragmentState fragmentState) {
    this.fragmentState = fragmentState;
    const fragment = this.fragmentState.state;
    descriptor.fragment = &fragment;

    id = wgpuDeviceCreateRenderPipeline(device.id, &descriptor);
    this.descriptor = descriptor;
  }

  /// Release the given handle.
  void destroy() {
    if (id !is null) wgpuRenderPipelineDrop(id);
    id = null;
  }
}

/// An in-progress recording of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.RenderPass.html">wgpu::RenderPass</a>
struct RenderPass {
  import std.typecons : Tuple;

  package WGPURenderPassEncoder instance;
  /// Describes this `RenderPass`.
  RenderPassDescriptor descriptor;

  /// Create a color attachment for a render pass.
  ///
  /// Params:
  /// view = The view to use as an attachment.
  /// clearColor = Value with which to fill the given `view`.
  /// store = Whether data will be written to through this attachment. Defaults to `true`.
  ///
  /// Remarks: The render target is cleared its content is loaded, i.e. `LoadOp.clear` is used.
  /// SeeAlso: `CommandEncoder.beginRenderPass`
  static RenderPassColorAttachment colorAttachment(TextureView view, Color clearColor, Flag!"store" store = Yes.store) {
    return colorAttachment(view, null, LoadOp.clear, clearColor, store);
  }
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
  /// If the bind group has dynamic offsets, provide them in order of their declaration. These offsets must be aligned to `BIND_BUFFER_ALIGNMENT`.
  void setBindGroup(const uint index, BindGroup bindGroup, const uint[] offsets = []) {
    wgpuRenderPassEncoderSetBindGroup(
      instance, index, bindGroup.id, offsets.length.to!uint, offsets.length ? offsets.ptr : null
    );
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
  void draw(uint vertexCount, uint instanceCount, uint firstVertex = 0, uint firstInstance = 0) {
    wgpuRenderPassEncoderDraw(instance, vertexCount, instanceCount, firstVertex, firstInstance);
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
