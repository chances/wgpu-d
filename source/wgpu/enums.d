/// Authors: Chance Snow
/// Copyright: Copyright © 2020-2023 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.enums;

import std.typecons : BitFlags, Yes;

import wgpu_bindings;

///
enum AdapterType : WGPUAdapterType {
  ///
  discreteGpu,
  ///
  integratedGpu,
  ///
  cpu,
  ///
  unknown,
  force32 = cast(WGPUAdapterType) 0x7FFFFFFF
}

///
enum AddressMode : WGPUAddressMode {
  ///
  repeat,
  ///
  mirrorRepeat,
  ///
  clampToEdge,
  force32 = cast(WGPUAddressMode) 0x7FFFFFFF
}

///
enum InstanceBackend : WGPUInstanceBackend {
  ///
  vulkan = WGPUInstanceBackend_Vulkan,
  ///
  gl = WGPUInstanceBackend_GL,
  ///
  metal = WGPUInstanceBackend_Metal,
  ///
  dx12 = WGPUInstanceBackend_DX12,
  ///
  dx11 = WGPUInstanceBackend_DX11,
  ///
  browserWebGPU = WGPUInstanceBackend_BrowserWebGPU,
  ///
  primary = WGPUInstanceBackend_Primary,
  ///
  secondary = WGPUInstanceBackend_Secondary,
  ///
  all = WGPUInstanceBackend_Force32,
  ///
  none = WGPUInstanceBackend_None,
  force32 = cast(WGPUInstanceBackend) 0x7FFFFFFF
}

/// Represents the graphics backends that wgpu can use.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Backends.html">wgpu::Backends</a>
enum BackendType : WGPUBackendType {
  ///
  undefined = WGPUBackendType_Undefined,
  ///
  _null = WGPUBackendType_Null,
  ///
  webGPU = WGPUBackendType_WebGPU,
  ///
  d3d11 = WGPUBackendType_D3D11,
  ///
  d3d12 = WGPUBackendType_D3D12,
  ///
  metal = WGPUBackendType_Metal,
  ///
  vulkan = WGPUBackendType_Vulkan,
  ///
  openGL = WGPUBackendType_OpenGL,
  ///
  openGLES = WGPUBackendType_OpenGLES,
  /// All the graphics APIs that for which wgpu offers first tier support.
  ///
  /// Vulkan, Metal, DirectX 12, and Browser WebGPU
  primary = cast(WGPUBackendType) (BackendType.vulkan | BackendType.metal | BackendType.d3d12 | BackendType.webGPU),
  /// All the graphics APIs that for which wgpu offers second tier support.
  ///
  /// That is, OpenGL and DirectX 11. These may be unsupported or are still experimental.
  secondary = cast(WGPUBackendType) (BackendType.openGL | BackendType.openGLES | BackendType.d3d11),
  force32 = cast(WGPUBackendType) 0x7FFFFFFF
}

///
enum BlendFactor : WGPUBlendFactor {
  ///
  zero,
  ///
  one,
  ///
  src,
  ///
  oneMinusSrc,
  ///
  srcAlpha,
  ///
  oneMinusSrcAlpha,
  ///
  dst,
  ///
  oneMinusDst,
  ///
  dstAlpha,
  ///
  oneMinusDstAlpha,
  ///
  srcAlphaSaturated,
  ///
  constant,
  ///
  oneMinusConstant,
  force32 = cast(WGPUBlendFactor) 0x7FFFFFFF
}

///
enum BlendOperation : WGPUBlendOperation {
  ///
  add,
  ///
  subtract,
  ///
  reverseSubtract,
  ///
  min,
  ///
  max,
  force32 = cast(WGPUBlendOperation) 0x7FFFFFFF
}

///
enum BufferBindingType : WGPUBufferBindingType {
  ///
  undefined,
  ///
  uniform,
  ///
  storage,
  ///
  readOnlyStorage,
  force32 = cast(WGPUBufferBindingType) 0x7FFFFFFF
}

/// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
enum BufferMapAsyncStatus : WGPUBufferMapAsyncStatus {
  ///
  success,
  ///
  error,
  ///
  unknown,
  ///
  deviceLost,
  ///
  destroyedBeforeCallback,
  ///
  unmappedBeforeCallback,
  force32 = cast(WGPUBufferMapAsyncStatus) 0x7FFFFFFF
}

///
enum CompareFunction : WGPUCompareFunction {
  ///
  undefined,
  ///
  never,
  ///
  less,
  ///
  lessEqual,
  ///
  greater,
  ///
  greaterEqual,
  ///
  equal,
  ///
  notEqual,
  ///
  always,
  force32 = cast(WGPUCompareFunction) 0x7FFFFFFF
}

///
enum CompilationMessageType : WGPUCompilationMessageType {
  ///
  error,
  ///
  warning,
  ///
  info,
  force32 = cast(WGPUCompilationMessageType) 0x7FFFFFFF
}

///
enum CreatePipelineAsyncStatus : WGPUCreatePipelineAsyncStatus {
  ///
  success,
  ///
  error,
  ///
  deviceLost,
  ///
  deviceDestroyed,
  ///
  unknown,
  force32 = cast(WGPUCreatePipelineAsyncStatus) 0x7FFFFFFF
}

/// Type of <a href="https://en.wikipedia.org/wiki/Back-face_culling">face culling</a> to use during graphic pipeline rasterization.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/enum.Face.html">wgpu::Face</a>
enum CullMode : WGPUCullMode {
  ///
  none,
  ///
  front,
  ///
  back,
  force32 = cast(WGPUCullMode) 0x7FFFFFFF
}

///
enum DeviceLostReason : WGPUDeviceLostReason {
  ///
  undefined,
  ///
  destroyed,
  force32 = cast(WGPUDeviceLostReason) 0x7FFFFFFF
}

///
enum ErrorFilter : WGPUErrorFilter {
  ///
  none,
  ///
  validation,
  ///
  outOfMemory,
  force32 = cast(WGPUErrorFilter) 0x7FFFFFFF
}

///
enum ErrorType : WGPUErrorType {
  ///
  noError,
  ///
  validation,
  ///
  outOfMemory,
  ///
  unknown,
  ///
  deviceLost,
  force32 = cast(WGPUErrorType) 0x7FFFFFFF
}

/// Features that are not guaranteed to be supported.
///
/// These are either part of the webgpu standard, or are extension features supported by wgpu when targeting native.
///
/// If you want to use a feature, you need to first verify that the adapter supports the feature. If the adapter
/// does not support the feature, requesting a device with it enabled will panic.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Features.html">wgpu::Features</a>
enum FeatureName : WGPUFeatureName {
  ///
  undefined,
  ///
  depthClamping,
  ///
  depth24UnormStencil8,
  ///
  depth32FloatStencil8,
  ///
  timestampQuery,
  ///
  pipelineStatisticsQuery,
  ///
  textureCompressionBc,
  force32 = cast(WGPUFeatureName) 0x7FFFFFFF
}

///
enum FilterMode : WGPUFilterMode {
  ///
  nearest,
  ///
  linear,
  force32 = cast(WGPUFilterMode) 0x7FFFFFFF
}

///
enum MipmapFilterMode : WGPUMipmapFilterMode {
  ///
  nearest,
  ///
  linear,
  force32 = cast(WGPUMipmapFilterMode) 0x7FFFFFFF
}

/// Specifies the vertex order for faces to be considered front-facing.
enum FrontFace : WGPUFrontFace {
  /// Clockwise ordered faces will be considered front-facing.
  cw,
  /// Counter-clockwise ordered faces will be considered front-facing.
  ccw,
  force32 = cast(WGPUFrontFace) 0x7FFFFFFF
}

/// When drawing strip topologies with indices, this is the required format for the index buffer.
/// This has no effect on non-indexed or non-strip draws.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/enum.IndexFormat.html">wgpu::IndexFormat</a>
enum IndexFormat : WGPUIndexFormat {
  ///
  undefined,
  ///
  uint16,
  ///
  uint32,
  force32 = cast(WGPUIndexFormat) 0x7FFFFFFF
}

///
enum LoadOp : WGPULoadOp {
  ///
  undefined,
  ///
  clear,
  ///
  load,
  force32 = cast(WGPULoadOp) 0x7FFFFFFF
}

///
enum PipelineStatisticName : WGPUPipelineStatisticName {
  ///
  vertexShaderInvocations,
  ///
  clipperInvocations,
  ///
  clipperPrimitivesOut,
  ///
  fragmentShaderInvocations,
  ///
  computeShaderInvocations,
  force32 = cast(WGPUPipelineStatisticName) 0x7FFFFFFF
}

///
enum PowerPreference : WGPUPowerPreference {
  ///
  undefined,
  ///
  lowPower,
  ///
  highPerformance,
  force32 = cast(WGPUPowerPreference) 0x7FFFFFFF
}

///
enum PresentMode : WGPUPresentMode {
  ///
  immediate,
  ///
  mailbox,
  ///
  fifo,
  force32 = cast(WGPUPresentMode) 0x7FFFFFFF
}

/// The primitive topology used to interpret vertices.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/enum.PrimitiveTopology.html">wgpu::PrimitiveTopology</a>
enum PrimitiveTopology : WGPUPrimitiveTopology {
  /// Vertex data is a list of points. Each vertex is a new point.
  pointList,
  /// Vertex data is a list of lines. Each pair of vertices composes a new line.
  ///
  /// Vertices `0 1 2 3` create two lines: `0-1` and `2-3`.
  lineList,
  /// Vertex data is a strip of lines. Each set of two adjacent vertices form a line.
  ///
  /// Vertices `0 1 2 3` create three lines: `0-1`, `1-2`, and `2-3`.
  lineStrip,
  /// Vertex data is a list of triangles. Each set of 3 vertices composes a new triangle.
  ///
  /// Vertices `0 1 2 3 4 5` create two triangles: `0 1 2` and `3 4 5`.
  triangleList,
  /// Vertex data is a triangle strip. Each set of three adjacent vertices form a triangle.
  ///
  /// Vertices `0 1 2 3 4 5` creates four triangles: `0 1 2`, `2 1 3`, `3 2 4`, and `4 3 5`.
  triangleStrip,
  ///
  force32 = cast(WGPUPrimitiveTopology) 0x7FFFFFFF
}

///
enum QueryType : WGPUQueryType {
  ///
  occlusion,
  ///
  pipelineStatistics,
  ///
  timestamp,
  force32 = cast(WGPUQueryType) 0x7FFFFFFF
}

///
enum QueueWorkDoneStatus : WGPUQueueWorkDoneStatus {
  ///
  success,
  ///
  error,
  ///
  unknown,
  ///
  deviceLost,
  force32 = cast(WGPUQueueWorkDoneStatus) 0x7FFFFFFF
}

///
enum RequestAdapterStatus : WGPURequestAdapterStatus {
  ///
  success,
  ///
  unavailable,
  ///
  error,
  ///
  unknown,
  force32 = cast(WGPURequestAdapterStatus) 0x7FFFFFFF
}

///
enum RequestDeviceStatus : WGPURequestDeviceStatus {
  ///
  success,
  ///
  error,
  ///
  unknown,
  force32 = cast(WGPURequestDeviceStatus) 0x7FFFFFFF
}

///
enum SType : WGPUSType {
  ///
  invalid,
  ///
  surfaceDescriptorFromMetalLayer,
  ///
  surfaceDescriptorFromWindowsHwnd,
  ///
  surfaceDescriptorFromXlibWindow,
  ///
  surfaceDescriptorFromCanvasHtmlSelector,
  ///
  shaderModuleSpirvDescriptor,
  ///
  shaderModuleWgslDescriptor,
  ///
  primitiveDepthClipControl,
  ///
  surfaceDescriptorFromWaylandSurface,
  ///
  surfaceDescriptorFromAndroidNativeWindow,
  ///
  surfaceDescriptorFromXcbWindow,
  ///
  renderPassDescriptorMaxDrawCount,
  force32 = cast(WGPUSType) 0x7FFFFFFF
}

///
enum SamplerBindingType : WGPUSamplerBindingType {
  ///
  undefined,
  ///
  filtering,
  ///
  nonFiltering,
  ///
  comparison,
  force32 = cast(WGPUSamplerBindingType) 0x7FFFFFFF
}

///
enum StencilOperation : WGPUStencilOperation {
  ///
  keep,
  ///
  zero,
  ///
  replace,
  ///
  invert,
  ///
  incrementClamp,
  ///
  decrementClamp,
  ///
  incrementWrap,
  ///
  decrementWrap,
  force32 = cast(WGPUStencilOperation) 0x7FFFFFFF
}

///
enum StorageTextureAccess : WGPUStorageTextureAccess {
  ///
  undefined,
  ///
  writeOnly,
  force32 = cast(WGPUStorageTextureAccess) 0x7FFFFFFF
}

///
enum StoreOp : WGPUStoreOp {
  ///
  undefined,
  ///
  store,
  ///
  discard,
  force32 = cast(WGPUStoreOp) 0x7FFFFFFF
}

///
enum TextureAspect : WGPUTextureAspect {
  ///
  all,
  ///
  stencilOnly,
  ///
  depthOnly,
  force32 = cast(WGPUTextureAspect) 0x7FFFFFFF
}

///
enum TextureDimension : WGPUTextureDimension {
  ///
  _1d,
  ///
  _2d,
  ///
  _3d,
  force32 = cast(WGPUTextureDimension) 0x7FFFFFFF
}

///
enum TextureFormat : WGPUTextureFormat {
  ///
  undefined,
  ///
  r8Unorm,
  ///
  r8Snorm,
  ///
  r8Uint,
  ///
  r8Sint,
  ///
  r16Uint,
  ///
  r16Sint,
  ///
  r16Float,
  ///
  rg8Unorm,
  ///
  rg8Snorm,
  ///
  rg8Uint,
  ///
  rg8Sint,
  ///
  r32Float,
  ///
  r32Uint,
  ///
  r32Sint,
  ///
  rg16Uint,
  ///
  rg16Sint,
  ///
  rg16Float,
  ///
  rgba8Unorm,
  ///
  rgba8UnormSrgb,
  ///
  rgba8Snorm,
  ///
  rgba8Uint,
  ///
  rgba8Sint,
  ///
  bgra8Unorm,
  ///
  bgra8UnormSrgb,
  ///
  rgb10a2Unorm,
  ///
  rg11b10Ufloat,
  ///
  rgb9e5Ufloat,
  ///
  rg32Float,
  ///
  rg32Uint,
  ///
  rg32Sint,
  ///
  rgba16Uint,
  ///
  rgba16Sint,
  ///
  rgba16Float,
  ///
  rgba32Float,
  ///
  rgba32Uint,
  ///
  rgba32Sint,
  ///
  stencil8,
  ///
  depth16Unorm,
  ///
  depth24Plus,
  ///
  depth24PlusStencil8,
  ///
  depth32Float,
  ///
  depth32FloatStencil8,
  ///
  bc1rgbaUnorm,
  ///
  bc1rgbaUnormSrgb,
  ///
  bc2rgbaUnorm,
  ///
  bc2rgbaUnormSrgb,
  ///
  bc3rgbaUnorm,
  ///
  bc3rgbaUnormSrgb,
  ///
  bc4rUnorm,
  ///
  bc4rSnorm,
  ///
  bc5rgUnorm,
  ///
  bc5rgSnorm,
  ///
  bc6hrgbUfloat,
  ///
  bc6hrgbFloat,
  ///
  bc7rgbaUnorm,
  ///
  bc7rgbaUnormSrgb,
  ///
  etc2Rgb8Unorm,
  ///
  etc2Rgb8UnormSrgb,
  ///
  etc2Rgb8A1Unorm,
  ///
  etc2Rgb8A1UnormSrgb,
  ///
  etc2Rgba8Unorm,
  ///
  etc2Rgba8UnormSrgb,
  ///
  eacR11Unorm,
  ///
  eacR11Snorm,
  ///
  eacRg11Unorm,
  ///
  eacRg11Snorm,
  ///
  astc4x4Unorm,
  ///
  astc4x4UnormSrgb,
  ///
  astc5x4Unorm,
  ///
  astc5x4UnormSrgb,
  ///
  astc5x5Unorm,
  ///
  astc5x5UnormSrgb,
  ///
  astc6x5Unorm,
  ///
  astc6x5UnormSrgb,
  ///
  astc6x6Unorm,
  ///
  astc6x6UnormSrgb,
  ///
  astc8x5Unorm,
  ///
  astc8x5UnormSrgb,
  ///
  astc8x6Unorm,
  ///
  astc8x6UnormSrgb,
  ///
  astc8x8Unorm,
  ///
  astc8x8UnormSrgb,
  ///
  astc10x5Unorm,
  ///
  astc10x5UnormSrgb,
  ///
  astc10x6Unorm,
  ///
  astc10x6UnormSrgb,
  ///
  astc10x8Unorm,
  ///
  astc10x8UnormSrgb,
  ///
  astc10x10Unorm,
  ///
  astc10x10UnormSrgb,
  ///
  astc12x10Unorm,
  ///
  astc12x10UnormSrgb,
  ///
  astc12x12Unorm,
  ///
  astc12x12UnormSrgb,
  force32 = cast(WGPUTextureFormat) 0x7FFFFFFF
}

/// Specific type of a sample in a texture binding.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/enum.TextureSampleType.html">wgpu::TextureSampleType</a>
enum TextureSampleType : WGPUTextureSampleType {
  ///
  undefined,
  ///
  _float,
  ///
  unfilterableFloat,
  ///
  depth,
  ///
  sint,
  ///
  _uint,
  force32 = cast(WGPUTextureSampleType) 0x7FFFFFFF
}

///
enum TextureViewDimension : WGPUTextureViewDimension {
  ///
  undefined,
  ///
  _1d,
  ///
  _2d,
  ///
  _2dArray,
  ///
  cube,
  ///
  cubeArray,
  ///
  _3d,
  force32 = cast(WGPUTextureViewDimension) 0x7FFFFFFF
}

///
enum VertexFormat : WGPUVertexFormat {
  ///
  undefined,
  ///
  uint8x2,
  ///
  uint8x4,
  ///
  sint8x2,
  ///
  sint8x4,
  ///
  unorm8x2,
  ///
  unorm8x4,
  ///
  snorm8x2,
  ///
  snorm8x4,
  ///
  uint16x2,
  ///
  uint16x4,
  ///
  sint16x2,
  ///
  sint16x4,
  ///
  unorm16x2,
  ///
  unorm16x4,
  ///
  snorm16x2,
  ///
  snorm16x4,
  ///
  float16x2,
  ///
  float16x4,
  ///
  float32,
  ///
  float32x2,
  ///
  float32x3,
  ///
  float32x4,
  ///
  uint32,
  ///
  uint32x2,
  ///
  uint32x3,
  ///
  uint32x4,
  ///
  sint32,
  ///
  sint32x2,
  ///
  sint32x3,
  ///
  sint32x4,
  force32 = cast(WGPUVertexFormat) 0x7FFFFFFF
}

///
enum VertexStepMode : WGPUVertexStepMode {
  ///
  vertex,
  ///
  instance,
  force32 = cast(WGPUVertexStepMode) 0x7FFFFFFF
}

/// Different ways that you can use a buffer.
///
/// The usages determine what kind of memory the buffer is allocated from and what actions the buffer can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.BufferUsages.html">wgpu::BufferUsages</a>
enum BufferUsage : WGPUBufferUsage {
  ///
  none = WGPUBufferUsage_None,
  ///
  mapRead = WGPUBufferUsage_MapRead,
  ///
  mapWrite = WGPUBufferUsage_MapWrite,
  ///
  copySrc = WGPUBufferUsage_CopySrc,
  ///
  copyDst = WGPUBufferUsage_CopyDst,
  ///
  index = WGPUBufferUsage_Index,
  ///
  vertex = WGPUBufferUsage_Vertex,
  ///
  uniform = WGPUBufferUsage_Uniform,
  ///
  storage = WGPUBufferUsage_Storage,
  ///
  indirect = WGPUBufferUsage_Indirect,
  ///
  queryResolve = WGPUBufferUsage_QueryResolve,
  force32 = cast(WGPUBufferUsage) 0x7FFFFFFF
}

///
alias BufferUsageFlags = BitFlags!(BufferUsage, Yes.unsafe);

/// Mask which enables/disables writes to different color/alpha channel.
/// Disabled color channels will not be written to.
enum ColorWriteMask : WGPUColorWriteMask {
  ///
  none = WGPUColorWriteMask_None,
  ///
  red = WGPUColorWriteMask_Red,
  ///
  green = WGPUColorWriteMask_Green,
  ///
  blue = WGPUColorWriteMask_Blue,
  ///
  alpha = WGPUColorWriteMask_Alpha,
  ///
  all = WGPUColorWriteMask_All,
  force32 = cast(WGPUColorWriteMask) 0x7FFFFFFF
}

///
alias ColorWriteMaskFlags = BitFlags!(ColorWriteMask, Yes.unsafe);

///
enum MapMode : WGPUMapMode {
  ///
  none,
  ///
  read,
  ///
  write,
  force32 = cast(WGPUMapMode) 0x7FFFFFFF
}

/// Describes the shader stages that a binding will be visible from.
///
/// These can be combined in a bitwise combination.
///
/// For example, something that is visible from both vertex and fragment shaders can be defined as:
///
/// `ShaderStage.vertex | ShaderStage.fragment`
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.ShaderStages.html">wgpu::ShaderStages</a>
enum ShaderStage : WGPUShaderStage {
  ///
  none = WGPUShaderStage_None,
  ///
  vertex = WGPUShaderStage_Vertex,
  ///
  fragment = WGPUShaderStage_Fragment,
  ///
  compute = WGPUShaderStage_Compute,
  force32 = cast(WGPUShaderStage) 0x7FFFFFFF
}

///
alias ShaderStageFlags = BitFlags!(ShaderStage, Yes.unsafe);

/// Different ways that you can use a texture.
///
/// The usages determine what kind of memory the texture is allocated from and what actions the texture can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.TextureUsages.html">wgpu::TextureUsages</a>
enum TextureUsage : WGPUTextureUsage {
  ///
  none = WGPUTextureUsage_None,
  ///
  copySrc = WGPUTextureUsage_CopySrc,
  ///
  copyDst = WGPUTextureUsage_CopyDst,
  ///
  textureBinding = WGPUTextureUsage_TextureBinding,
  ///
  storageBinding = WGPUTextureUsage_StorageBinding,
  ///
  renderAttachment = WGPUTextureUsage_RenderAttachment,
  force32 = cast(WGPUTextureUsage) 0x7FFFFFFF
}

///
alias TextureUsageFlags = BitFlags!(TextureUsage, Yes.unsafe);

import wgpu.api : BlendComponent, BlendState;

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
