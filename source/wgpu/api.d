/// An idiomatic D wrapper for <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a>.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.api;

import bindbc.wgpu;
import core.stdc.config : c_ulong;
import std.conv : to;
import std.string : fromStringz, toStringz;
import std.traits : fullyQualifiedName;

/// Version of <a href="https://github.com/gfx-rs/wgpu-native">wgpu-native</a> this library binds.
/// See_Also: <a href="https://github.com/gfx-rs/wgpu-native/releases/tag/v0.6.0">github.com/gfx-rs/wgpu-native/releases/tag/v0.6.0</a>
static const VERSION = "0.6.0";
/// Buffer-Texture copies must have `bytes_per_row` aligned to this number.
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

alias WgpuId = c_ulong;
alias Features = WGPUFeatures;

/// How edges should be handled in texture addressing.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.AddressMode.html">wgpu::AddressMode</a>
enum AddressMode {
  /// Clamp the value to the edge of the texture.
  ///
  /// -0.25 -> 0.0 1.25 -> 1.0
  clampToEdge = 0,
  /// Repeat the texture in a tiling fashion.
  ///
  /// -0.25 -> 0.75 1.25 -> 0.25
  repeat = 1,
  /// Repeat the texture, mirroring it every repeat.
  ///
  /// -0.25 -> 0.25 1.25 -> 0.75
  mirrorRepeat = 2
}
/// Backends supported by wgpu.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.Backend.html">wgpu::Backend</a>
enum Backend : ubyte {
  empty = 0,
  vulkan = 1,
  metal = 2,
  dx12 = 3,
  dx11 = 4,
  gl = 5,
  browserWebGpu = 6
}
/// Specific type of a binding.
///
/// See_Also:
/// $(UL
///   $(LI <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.BindingType.html">wgpu::BindingType</a>)
///   $(LI <a href="https://gpuweb.github.io/gpuweb/#dictdef-gpubindgrouplayoutentry">`GPUBindGroupLayoutEntry`</a> in the WebGPU specification.)
/// )
enum BindingType : uint {
  /// A buffer for uniform values.
  uniformBuffer = 0,
  /// A storage buffer.
  storageBuffer = 1,
  readonlyStorageBuffer = 2,
  /// A sampler that can be used to sample a texture.
  sampler = 3,
  comparisonSampler = 4,
  /// A texture.
  sampledTexture = 5,
  readonlyStorageTexture = 6,
  writeonlyStorageTexture = 7
}
/// Alpha blend factor.
///
/// Alpha blending is very complicated: see the OpenGL or Vulkan spec for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.BlendFactor.html">wgpu::BlendFactor</a>
enum BlendFactor {
  zero = 0,
  one = 1,
  srcColor = 2,
  oneMinusSrcColor = 3,
  srcAlpha = 4,
  oneMinusSrcAlpha = 5,
  dstColor = 6,
  oneMinusDstColor = 7,
  dstAlpha = 8,
  oneMinusDstAlpha = 9,
  srcAlphaSaturated = 10,
  blendColor = 11,
  oneMinusBlendColor = 12
}
/// Alpha blend operation.
///
/// Alpha blending is very complicated: see the OpenGL or Vulkan spec for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.BlendOperation.html">wgpu::BlendOperation</a>
enum BlendOperation {
  add = 0,
  subtract = 1,
  reverseSubtract = 2,
  min = 3,
  max = 4
}
/// Supported physical device types.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.DeviceType.html">wgpu::CDeviceType</a>
enum DeviceType : ubyte {
  /// Other.
  other = 0,
  /// Integrated GPU with shared CPU/GPU memory.
  integratedGpu,
  /// Discrete GPU with separate CPU/GPU memory.
  discreteGpu,
  /// Virtual / Hosted.
  virtualGpu,
  /// Cpu / Software Rendering.
  cpu
}
/// Comparison function used for depth and stencil operations.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.CompareFunction.html">wgpu::CompareFunction</a>
enum CompareFunction {
  /// Invalid value, do not use
  undefined = 0,
  /// Function never passes
  never = 1,
  /// Function passes if new value less than existing value
  less = 2,
  /// Function passes if new value is equal to existing value
  equal = 3,
  /// Function passes if new value is less than or equal to existing value
  lessEqual = 4,
  /// Function passes if new value is greater than existing value
  greater = 5,
  /// Function passes if new value is not equal to existing value
  notEqual = 6,
  /// Function passes if new value is greater than or equal to existing value
  greaterEqual = 7,
  /// Function always passes
  always = 8
}
/// Type of faces to be culled.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.CullMode.html">wgpu::CullMode</a>
enum CullMode {
  /// No faces should be culled
  none = 0,
  /// Front faces should be culled
  front = 1,
  /// Back faces should be culled
  back = 2
}
/// Texel mixing mode when sampling between texels.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.FilterMode.html">wgpu::FilterMode</a>
enum FilterMode {
  /// Nearest neighbor sampling.
  ///
  /// This creates a pixelated effect when used as a mag filter
  nearest = 0,
  /// Linear Interpolation
  ///
  /// This makes textures smooth but blurry when used as a mag filter.
  linear = 1
}
/// Winding order which classifies the "front" face.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.FrontFace.html">wgpu::FrontFace</a>
enum FrontFace {
  /// Triangles with vertices in counter clockwise order are considered the front face.
  ///
  /// This is the default with right handed coordinate spaces.
  ccw = 0,
  /// Triangles with vertices in clockwise order are considered the front face.
  ///
  /// This is the default with left handed coordinate spaces.
  cw = 1
}
/// Format of indices used with pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.IndexFormat.html">wgpu::IndexFormat</a>
enum IndexFormat {
  /// Indices are 16 bit unsigned integers.
  uint16 = 0,
  /// Indices are 32 bit unsigned integers.
  uint32 = 1
}
/// Rate that determines when vertex data is advanced.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.InputStepMode.html">wgpu::InputStepMode</a>
enum InputStepMode {
  /// Input data is advanced every vertex. This is the standard value for vertex data.
  vertex = 0,
  /// Input data is advanced every instance.
  instance = 1
}
/// Operation to perform to the output attachment at the start of a renderpass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.LoadOp.html">wgpu::LoadOp</a>
enum LoadOp : WGPULoadOp {
  /// Clear the output attachment with the clear color. Clearing is faster than loading.
  clear = WGPULoadOp.Clear,
  /// Do not clear output attachment.
  load = WGPULoadOp.Load
}
/// Log level. Set it by calling `wgpuSetLogLevel`.
enum LogLevel {
  off = 0,
  error = 1,
  warn = 2,
  info = 3,
  debug_ = 4,
  trace = 5
}

/// Set WGPU's log level.
void wgpuSetLogLevel(LogLevel logLevel) {
  wgpu_set_log_level(logLevel.to!uint.to!WGPULogLevel);
}

/// Power Preference when choosing a physical adapter.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.PowerPreference.html">wgpu::PowerPreference</a>
enum PowerPreference : WGPUPowerPreference {
  /// Prefer low power when on battery, high performance when on mains.
  default_ = WGPUPowerPreference.Default,
  /// Adapter that uses the least possible power. This is often an integerated GPU.
  lowPower = WGPUPowerPreference.LowPower,
  /// Adapter that has the highest performance. This is often a discrete GPU.
  highPerformance = WGPUPowerPreference.HighPerformance
}
/// Behavior of the presentation engine based on frame rate.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.PresentMode.html">wgpu::PresentMode</a>
enum PresentMode {
  /// The presentation engine does **not** wait for a vertical blanking period and
  /// the request is presented immediately. This is a low-latency presentation mode,
  /// but visible tearing may be observed. Will fallback to `Fifo` if unavailable on the
  /// selected  platform and backend. Not optimal for mobile.
  immediate = 0,
  /// The presentation engine waits for the next vertical blanking period to update
  /// the current image, but frames may be submitted without delay. This is a low-latency
  /// presentation mode and visible tearing will **not** be observed. Will fallback to `Fifo`
  /// if unavailable on the selected platform and backend. Not optimal for mobile.
  mailbox = 1,
  /// The presentation engine waits for the next vertical blanking period to update
  /// the current image. The framerate will be capped at the display refresh rate,
  /// corresponding to the `VSync`. Tearing cannot be observed. Optimal for mobile.
  fifo = 2
}
/// Primitive type the input mesh is composed of.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.PrimitiveTopology.html">wgpu::PrimitiveTopology</a>
enum PrimitiveTopology {
  /// Vertex data is a list of points. Each vertex is a new point.
  pointList = 0,
  /// Vertex data is a list of lines. Each pair of vertices composes a new line.
  ///
  /// Vertices `0 1 2 3` create two lines `0 1` and `2 3`
  lineList = 1,
  /// Vertex data is a strip of lines. Each set of two adjacent vertices form a line.
  ///
  /// Vertices `0 1 2 3` create three lines `0 1`, `1 2`, and `2 3`.
  lineStrip = 2,
  /// Vertex data is a list of triangles. Each set of 3 vertices composes a new triangle.
  ///
  /// Vertices `0 1 2 3 4 5` create two triangles `0 1 2` and `3 4 5`
  triangleList = 3,
  /// Vertex data is a triangle strip. Each set of three adjacent vertices form a triangle.
  ///
  /// Vertices `0 1 2 3 4 5` creates four triangles `0 1 2`, `2 1 3`, `3 2 4`, and `4 3 5`
  triangleStrip = 4
}
/// Unknown.
enum SType {
  invalid = 0,
  surfaceDescriptorFromMetalLayer = 1,
  surfaceDescriptorFromWindowsHwnd = 2,
  surfaceDescriptorFromXlib = 3,
  surfaceDescriptorFromHtmlCanvasId = 4,
  shaderModuleSpirvDescriptor = 5,
  shaderModuleWgslDescriptor = 6,
  /// Placeholder value until real value can be determined
  anisotropicFiltering = 268_435_456,
  force32 = 2_147_483_647
}
/// Operation to perform on the stencil value.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.StencilOperation.html">wgpu::StencilOperation</a>
enum StencilOperation {
  /// Keep stencil value unchanged.
  keep = 0,
  /// Set stencil value to zero.
  zero = 1,
  /// Replace stencil value with value provided in most recent call to [`RenderPass::set_stencil_reference`].
  replace = 2,
  /// Bitwise inverts stencil value.
  invert = 3,
  /// Increments stencil value by one, clamping on overflow.
  incrementClamp = 4,
  /// Decrements stencil value by one, clamping on underflow.
  decrementClamp = 5,
  /// Increments stencil value by one, wrapping on overflow.
  incrementWrap = 6,
  /// Decrements stencil value by one, wrapping on underflow.
  decrementWrap = 7
}
/// Operation to perform to the output attachment at the end of a renderpass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.StoreOp.html">wgpu::StoreOp</a>
enum StoreOp : WGPUStoreOp {
  /// Clear the render target. If you don't care about the contents of the target, this can be faster.
  clear = WGPUStoreOp.Clear,
  /// Store the result of the renderpass.
  store = WGPUStoreOp.Store
}
/// Status of the recieved swapchain image.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.SwapChainStatus.html">wgpu::SwapChainStatus</a>
enum SwapChainStatus {
  good,
  suboptimal,
  timeout,
  outdated,
  lost,
  outOfMemory
}
/// Kind of data the texture holds.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.TextureAspect.html">wgpu::TextureAspect</a>
enum TextureAspect {
  /// Depth, Stencil, and Color.
  all,
  /// Stencil.
  stencilOnly,
  /// Depth.
  depthOnly
}
/// Type of data shaders will read from a texture.
///
/// Only relevant for `BindingType.sampledTexture` bindings. See `TextureFormat` for more information.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.TextureComponentType.html">wgpu::TextureComponentType</a>
enum TextureComponentType {
  /// They see it as a floating point number `texture1D`, `texture2D` etc
  float_,
  /// They see it as a signed integer `itexture1D`, `itexture2D` etc
  sint,
  /// They see it as a unsigned integer `utexture1D`, `utexture2D` etc
  uint_
}
/// Dimensionality of a texture.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.TextureDimension.html">wgpu::TextureDimension</a>
enum TextureDimension : WGPUTextureDimension {
  /// 1D texture
  d1 = WGPUTextureDimension.D1,
  /// 2D texture
  d2 = WGPUTextureDimension.D2,
  /// 3D texture
  d3 = WGPUTextureDimension.D3
}
/// Underlying texture data format.
///
/// If there is a conversion in the format (such as srgb -> linear), The conversion listed is for
/// loading from texture in a shader. When writing to the texture, the opposite conversion takes place.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.TextureFormat.html">wgpu::TextureFormat</a>
enum TextureFormat : WGPUTextureFormat {
  /// Red channel only. 8 bit integer per channel. [0, 255] converted to/from float [0, 1] in shader.
  r8Unorm = WGPUTextureFormat.R8Unorm,
  /// Red channel only. 8 bit integer per channel. [-127, 127] converted to/from float [-1, 1] in shader.
  r8Snorm = WGPUTextureFormat.R8Snorm,
  /// Red channel only. 8 bit integer per channel. Unsigned in shader.
  r8Uint = WGPUTextureFormat.R8Uint,
  /// Red channel only. 8 bit integer per channel. Signed in shader.
  r8Sint = WGPUTextureFormat.R8Sint,
  /// Red channel only. 16 bit integer per channel. Unsigned in shader.
  r16Uint = WGPUTextureFormat.R16Uint,
  /// Red channel only. 16 bit integer per channel. Signed in shader.
  r16Sint = WGPUTextureFormat.R16Sint,
  /// Red channel only. 16 bit float per channel. Float in shader.
  r16Float = WGPUTextureFormat.R16Float,
  /// Red and green channels. 8 bit integer per channel. [0, 255] converted to/from float [0, 1] in shader.
  rg8Unorm = WGPUTextureFormat.Rg8Unorm,
  /// Red and green channels. 8 bit integer per channel. [-127, 127] converted to/from float [-1, 1] in shader.
  rg8Snorm = WGPUTextureFormat.Rg8Snorm,
  /// Red and green channels. 8 bit integer per channel. Unsigned in shader.
  rg8Uint = WGPUTextureFormat.Rg8Uint,
  /// Red and green channel s. 8 bit integer per channel. Signed in shader.
  rg8Sint = WGPUTextureFormat.Rg8Sint,
  /// Red channel only. 32 bit integer per channel. Unsigned in shader.
  r32Uint = WGPUTextureFormat.R32Uint,
  /// Red channel only. 32 bit integer per channel. Signed in shader.
  r32Sint = WGPUTextureFormat.R32Sint,
  /// Red channel only. 32 bit float per channel. Float in shader.
  r32Float = WGPUTextureFormat.R32Float,
  /// Red and green channels. 16 bit integer per channel. Unsigned in shader.
  rg16Uint = WGPUTextureFormat.Rg16Uint,
  /// Red and green channels. 16 bit integer per channel. Signed in shader.
  rg16Sint = WGPUTextureFormat.Rg16Sint,
  /// Red and green channels. 16 bit float per channel. Float in shader.
  rg16Float = WGPUTextureFormat.Rg16Float,
  /// Red, green, blue, and alpha channels. 8 bit integer per channel. [0, 255] converted to/from float [0, 1] in shader.
  rgba8Unorm = WGPUTextureFormat.Rgba8Unorm,
  /// Red, green, blue, and alpha channels. 8 bit integer per channel. Srgb-color [0, 255] converted to/from linear-color float [0, 1] in shader.
  rgba8UnormSrgb = WGPUTextureFormat.Rgba8UnormSrgb,
  /// Red, green, blue, and alpha channels. 8 bit integer per channel. [-127, 127] converted to/from float [-1, 1] in shader.
  rgba8Snorm = WGPUTextureFormat.Rgba8Snorm,
  /// Red, green, blue, and alpha channels. 8 bit integer per channel. Unsigned in shader.
  rgba8Uint = WGPUTextureFormat.Rgba8Uint,
  /// Red, green, blue, and alpha channels. 8 bit integer per channel. Signed in shader.
  rgba8Sint = WGPUTextureFormat.Rgba8Sint,
  /// Blue, green, red, and alpha channels. 8 bit integer per channel. [0, 255] converted to/from float [0, 1] in shader.
  bgra8Unorm = WGPUTextureFormat.Bgra8Unorm,
  /// Blue, green, red, and alpha channels. 8 bit integer per channel. Srgb-color [0, 255] converted to/from linear-color float [0, 1] in shader.
  bgra8UnormSrgb = WGPUTextureFormat.Bgra8UnormSrgb,
  /// Red, green, blue, and alpha channels. 10 bit integer for RGB channels, 2 bit integer for alpha channel. [0, 1023] ([0, 3] for alpha) converted to/from float [0, 1] in shader.
  rgb10a2Unorm = WGPUTextureFormat.Rgb10a2Unorm,
  /// Red, green, and blue channels. 11 bit float with no sign bit for RG channels. 10 bit float with no sign bti for blue channel. Float in shader.
  rg11b10Float = WGPUTextureFormat.Rg11b10Float,
  /// Red and green channels. 32 bit integer per channel. Unsigned in shader.
  rg32Uint = WGPUTextureFormat.Rg32Uint,
  /// Red and green channels. 32 bit integer per channel. Signed in shader.
  rg32Sint = WGPUTextureFormat.Rg32Sint,
  /// Red and green channels. 32 bit float per channel. Float in shader.
  rg32Float = WGPUTextureFormat.Rg32Float,
  /// Red, green, blue, and alpha channels. 16 bit integer per channel. Unsigned in shader.
  rgba16Uint = WGPUTextureFormat.Rgba16Uint,
  /// Red, green, blue, and alpha channels. 16 bit integer per channel. Signed in shader.
  rgba16Sint = WGPUTextureFormat.Rgba16Sint,
  /// Red, green, blue, and alpha channels. 16 bit float per channel. Float in shader.
  rgba16Float = WGPUTextureFormat.Rgba16Float,
  /// Red, green, blue, and alpha channels. 32 bit integer per channel. Unsigned in shader.
  rgba32Uint = WGPUTextureFormat.Rgba32Uint,
  /// Red, green, blue, and alpha channels. 32 bit integer per channel. Signed in shader.
  rgba32Sint = WGPUTextureFormat.Rgba32Sint,
  /// Red, green, blue, and alpha channels. 32 bit float per channel. Float in shader.
  rgba32Float = WGPUTextureFormat.Rgba32Float,
  /// Special depth format with 32 bit floating point depth.
  depth32Float = WGPUTextureFormat.Depth32Float,
  /// Special depth format with at least 24 bit integer depth.
  depth24Plus = WGPUTextureFormat.Depth24Plus,
  /// Special depth/stencil format with at least 24 bit integer depth and 8 bits integer stencil.
  depth24PlusStencil8 = WGPUTextureFormat.Depth24PlusStencil8
}
/// Dimensions of a particular texture view.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.TextureViewDimension.html">wgpu::TextureViewDimension</a>
enum TextureViewDimension {
  /// A one dimensional texture. `texture1D` in glsl shaders.
  d1,
  /// A two dimensional texture. `texture2D` in glsl shaders.
  d2,
  /// A two dimensional array texture. `texture2DArray` in glsl shaders.
  d2Array,
  /// A cubemap texture. `textureCube` in glsl shaders.
  cube,
  /// A cubemap array texture. `textureCubeArray` in glsl shaders.
  cubeArray,
  /// A three dimensional texture. `texture3D` in glsl shaders.
  d3
}
/// Vertex Format for a Vertex Attribute (input).
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/enum.VertexFormat.html">wgpu::VertexFormat</a>
enum VertexFormat {
  /// Two unsigned bytes (u8). `uvec2` in shaders.
  uchar2 = 0,
  /// Four unsigned bytes (u8). `uvec4` in shaders.
  uchar4 = 1,
  /// Two signed bytes (i8). `ivec2` in shaders.
  char2 = 2,
  /// Four signed bytes (i8). `ivec4` in shaders.
  char4 = 3,
  /// Two unsigned bytes (u8). [0, 255] converted to float [0, 1] `vec2` in shaders.
  uchar2Norm = 4,
  /// Four unsigned bytes (u8). [0, 255] converted to float [0, 1] `vec4` in shaders.
  uchar4Norm = 5,
  /// Two signed bytes (i8). [-127, 127] converted to float [-1, 1] `vec2` in shaders.
  char2Norm = 6,
  /// Four signed bytes (i8). [-127, 127] converted to float [-1, 1] `vec4` in shaders.
  char4Norm = 7,
  /// Two unsigned shorts (u16). `uvec2` in shaders.
  ushort2 = 8,
  /// Four unsigned shorts (u16). `uvec4` in shaders.
  ushort4 = 9,
  /// Two unsigned shorts (i16). `ivec2` in shaders.
  short2 = 10,
  /// Four unsigned shorts (i16). `ivec4` in shaders.
  short4 = 11,
  /// Two unsigned shorts (u16). [0, 65535] converted to float [0, 1] `vec2` in shaders.
  ushort2Norm = 12,
  /// Four unsigned shorts (u16). [0, 65535] converted to float [0, 1] `vec4` in shaders.
  ushort4Norm = 13,
  /// Two signed shorts (i16). [-32767, 32767] converted to float [-1, 1] `vec2` in shaders.
  short2Norm = 14,
  /// Four signed shorts (i16). [-32767, 32767] converted to float [-1, 1] `vec4` in shaders.
  short4Norm = 15,
  /// Two half-precision floats (no Rust equiv). `vec2` in shaders.
  half2 = 16,
  /// Four half-precision floats (no Rust equiv). `vec4` in shaders.
  half4 = 17,
  /// One single-precision float (f32). `float` in shaders.
  float_ = 18,
  /// Two single-precision floats (f32). `vec2` in shaders.
  float2 = 19,
  /// Three single-precision floats (f32). `vec3` in shaders.
  float3 = 20,
  /// Four single-precision floats (f32). `vec4` in shaders.
  float4 = 21,
  /// One unsigned int (u32). `uint` in shaders.
  uint_ = 22,
  /// Two unsigned ints (u32). `uvec2` in shaders.
  uint2 = 23,
  /// Three unsigned ints (u32). `uvec3` in shaders.
  uint3 = 24,
  /// Four unsigned ints (u32). `uvec4` in shaders.
  uint4 = 25,
  /// One signed int (i32). `int` in shaders.
  int_ = 26,
  /// Two signed ints (i32). `ivec2` in shaders.
  int2 = 27,
  /// Three signed ints (i32). `ivec3` in shaders.
  int3 = 28,
  /// Four signed ints (i32). `ivec4` in shaders.
  int4 = 29
}

/// Describes the shader stages that a binding will be visible from.
///
/// These can be combined in a bitwise combination.
///
/// For example, something that is visible from both vertex and fragment shaders can be defined as:
///
/// `ShaderStage.vertex | ShaderStage.fragment`
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ShaderStage.html">wgpu::ShaderStage</a>
enum ShaderStage : uint {
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
  mapRead = WGPUBufferUsage.MAP_READ,
  mapWrite = WGPUBufferUsage.MAP_WRITE,
  copySrc = WGPUBufferUsage.COPY_SRC,
  copyDst = WGPUBufferUsage.COPY_DST,
  index = WGPUBufferUsage.INDEX,
  vertex = WGPUBufferUsage.VERTEX,
  uniform = WGPUBufferUsage.UNIFORM,
  storage = WGPUBufferUsage.STORAGE,
  indirect = WGPUBufferUsage.INDIRECT
}

/// Different ways that you can use a texture.
///
/// The usages determine what kind of memory the texture is allocated from and what actions the texture can partake in.
///
/// These can be combined in a bitwise combination.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.TextureUsage.html">wgpu::TextureUsage</a>
enum TextureUsage : WGPUTextureUsage {
  copySrc = WGPUTextureUsage.COPY_SRC,
  copyDst = WGPUTextureUsage.COPY_DST,
  sampled = WGPUTextureUsage.SAMPLED,
  storage = WGPUTextureUsage.STORAGE,
  outputAttachment = WGPUTextureUsage.OUTPUT_ATTACHMENT
}

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
// TODO: Wrap `CommandEncoderDescriptor` so that it accepts `string` as the label
/// Describes a `CommandEncoder`.
alias CommandEncoderDescriptor = WGPUCommandEncoderDescriptor;
/// Describes a `CommandBuffer`.
alias CommandBufferDescriptor = WGPUCommandBufferDescriptor;
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
/// Describes a depth/stencil attachment to a `RenderPass`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPassDepthStencilAttachmentDescriptor.html">wgpu::RenderPassDepthStencilAttachmentDescriptor</a>
alias RenderPassDepthStencilAttachmentDescriptor = WGPURenderPassDepthStencilAttachmentDescriptor;
/// Describes a `ComputePipeline`.
alias ComputePipelineDescriptor = WGPUComputePipelineDescriptor;
/// Describes a `ComputePass`.
alias ComputePassDescriptor = WGPUComputePassDescriptor;

/// Metadata about a backend adapter.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.AdapterInfo.html">wgpu::AdapterInfo</a>
struct AdapterInfo {
  /// Adapter name.
  string name;
  /// Vendor PCI id of the adapter.
  size_t vendor;
  /// PCI id of the adapter.
  size_t device;
  /// Type of device.
  DeviceType deviceType;
  /// Backend used for device.
  Backend backend;
}

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
struct Limits {
  /// Amount of bind groups that can be attached to a pipeline at the same time. Defaults to 4. Higher is "better".
  uint maxBindGroups;
}

/// RGBA double precision color.
///
/// This is not to be used as a generic color type, only for specific wgpu interfaces.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Color.html">wgpu::Color</a>
struct Color {
  /// Red component
  double r;
  /// Green component
  double g;
  /// Blue component
  double b;
  /// Alpha component
  double a;
}

/// Origin of a copy to/from a texture.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.Origin3d.html">wgpu::Origin3d</a>
struct Origin3d {
  /// X component.
  uint x;
  /// Y component.
  uint y;
  /// Z component.
  uint z;

  /// Origin where `x`, `y`, and `z` are zero.
  static const zero = Origin3d(0, 0, 0);
}

/// Describes a color attachment to a `RenderPass`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPassColorAttachmentDescriptor.html">wgpu::RenderPassColorAttachmentDescriptor</a>
struct RenderPassColorAttachmentDescriptor {
  /// Texture attachment to render to. Must contain [`TextureUsage::OUTPUT_ATTACHMENT`].
  WGPUTextureViewId attachment;

  /// MSAA resolve target. Must contain [`TextureUsage::OUTPUT_ATTACHMENT`]. Must be `None` if
  /// attachment has 1 sample (does not have MSAA). This is not mandatory for rendering with multisampling,
  /// you can choose to resolve later or manually.
  WGPUOptionRef_TextureViewId resolveTarget;

  /// Color channel.
  PassChannel_Color channel;
}

/// Pair of load and store operations for an attachment aspect.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPassColorAttachmentDescriptor.html">wgpu::RenderPassColorAttachmentDescriptor</a>
struct PassChannel_Color {
  /// How data should be read through this attachment.
  LoadOp loadOp;
  /// How data should be stored through this attachment.
  StoreOp storeOp;
  /// Clear color for this `RenderPass`.
  Color clearColor;
  /// Whether this attachment is read only.
  bool readOnly;
}

/// Describes the attachments of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPassDescriptor.html">wgpu::RenderPassDescriptor</a>
struct RenderPassDescriptor {
  /// The color attachments of the render pass.
  const RenderPassColorAttachmentDescriptor[] colorAttachments;
  /// The depth and stencil attachment of the render pass, if any.
  const RenderPassDepthStencilAttachmentDescriptor* depthStencilAttachment;
}

/// View of a texture which can be used to copy to/from a buffer/texture.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/type.TextureCopyView.html">wgpu::TextureCopyView</a>
struct TextureCopyView {
  /// The texture to be copied to/from, i.e. `Texture.id`.
  WGPUTextureId texture;
  /// The target mip level of the texture.
  uint mipLevel;
  /// The base texel of the texture in the selected `mipLevel`.
  Origin3d origin;
}

extern (C) private void wgpu_request_adapter_callback(ulong id, void* data) {
  assert(data !is null);
  auto adapter = cast(Adapter*) data;
  assert(id > 0);
  adapter.id = id;
}

/// Additional information required when requesting an adapter.
///
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RequestAdapterOptions.html">wgpu::RequestAdapterOptions</a>
struct RequestAdapterOptions
{
  /// Power preference for the adapter.
  PowerPreference powerPreference;
  /// Surface that is required to be presentable with the requested adapter. This does not create the surface,
  /// only guarantees that the adapter can present to said surface.
  WgpuId compatibleSurface = 0;
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
    const options_ = WGPURequestAdapterOptions(
      options.powerPreference,
      options.compatibleSurface
    );
    const allowedBackends = Backend.vulkan | Backend.metal | Backend.dx12;
    wgpu_request_adapter_async(&options_, allowedBackends, false, &wgpu_request_adapter_callback, &this);
  }

  /// Release the given handle.
  void destroy() {
    if (ready) wgpu_adapter_destroy(id);
    id = 0;
  }

  /// Whether this Adapter handle has finished being requested and is ready for use.
  bool ready() @property const {
    return id > 0;
  }

  /// Information about this Adapter.
  AdapterInfo info() @property const {
    assert(ready);
    WGPUCAdapterInfo info;
    wgpu_adapter_get_info(id, &info);
    return AdapterInfo(
      fromStringz(info.name).to!string,
      info.vendor, info.device,
      info.device_type.to!uint.to!DeviceType,
      info.backend.to!uint.to!Backend
    );
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
    auto limits = wgpu_adapter_limits(id);
    return Limits(limits.max_bind_groups);
  }

  /// Requests a connection to a physical device, creating a logical device.
  ///
  /// Params:
  /// features = The sets of features the device supports.
  /// limits = The sets of limits the device supports.
  /// label = Optional label for the `Device`.
  Device requestDevice(const Features features, const Limits limits, string label = fullyQualifiedName!Device) {
    assert(ready);
    const limits_ = WGPUCLimits(limits.maxBindGroups);
    auto id = wgpu_adapter_request_device(id, features, &limits_, true, toStringz(label));
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

  /// Release the given handle.
  void destroy() {
    if (ready) wgpu_device_destroy(id);
    id = 0;
  }

  /// Whether this Device handle is valid and ready for use.
  ///
  /// If `false`, `Adapter.requestDevice` likely failed.
  bool ready() @property const {
    return id > 0;
  }

  /// List all features that were requested of this device.
  ///
  /// If any of these limits are exceeded, functions may panic.
  Features features() @property const {
    return wgpu_device_features(id);
  }

  /// List all limits that were requested of this device.
  ///
  /// If any of these limits are exceeded, functions may panic.
  Limits limits() @property const {
    return Limits(wgpu_device_limits(id).max_bind_groups);
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
    return CommandEncoder(wgpu_device_create_command_encoder(id, &descriptor), descriptor);
  }

  /// Creates a new bind group.
  BindGroup createBindGroup(const BindGroupDescriptor descriptor) {
    return BindGroup(wgpu_device_create_bind_group(id, &descriptor), descriptor);
  }

  /// Creates a bind group layout.
  BindGroupLayout createBindGroupLayout(const BindGroupLayoutDescriptor descriptor) {
    return BindGroupLayout(wgpu_device_create_bind_group_layout(id, &descriptor), descriptor);
  }

  /// Creates a bind group layout.
  PipelineLayout createPipelineLayout(const PipelineLayoutDescriptor descriptor) {
    return PipelineLayout(wgpu_device_create_pipeline_layout(id, &descriptor), descriptor);
  }

  /// Creates a render pipeline.
  RenderPipeline createRenderPipeline(const RenderPipelineDescriptor descriptor) {
    return RenderPipeline(wgpu_device_create_render_pipeline(id, &descriptor), descriptor);
  }

  /// Creates a compute pipeline.
  ComputePipeline createComputePipeline(const ComputePipelineDescriptor descriptor) {
    return ComputePipeline(wgpu_device_create_compute_pipeline(id, &descriptor), descriptor);
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
    return Texture(wgpu_device_create_texture(id, &descriptor), descriptor);
  }

  /// Creates a new `Sampler`.
  ///
  /// Params:
  /// descriptor = Specifies the behavior of the sampler.
  Sampler createSampler(const SamplerDescriptor descriptor) {
    return Sampler(wgpu_device_create_sampler(id, &descriptor), descriptor);
  }

  /// Create a new `SwapChain` which targets `surface`.
  SwapChain createSwapChain(const Surface surface, const SwapChainDescriptor descriptor) {
    return SwapChain(wgpu_device_create_swap_chain(id, surface.id, &descriptor), descriptor);
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
  version (D_Ddoc) {
    /// Create a new `Surface` from an Android handle.
    static Surface fromAndroid(void* androidNativeWindow) {
      return Surface(wgpu_create_surface_from_android(androidNativeWindow));
    }
    /// Create a new `Surface` from a Metal layer.
    static Surface fromMetalLayer(void* layer) {
      return Surface(wgpu_create_surface_from_metal_layer(layer));
    }
    /// Create a new `Surface` from a Wayland window handle.
    static Surface fromWayland(void* surface, void* display) {
      return Surface(wgpu_create_surface_from_wayland(surface, display));
    }
    /// Create a new `Surface` from a Windows window handle.
    static Surface fromWindowsHwnd(void* _hinstance, void* hwnd) {
      return Surface(wgpu_create_surface_from_windows_hwnd(_hinstance, hwnd));
    }
    /// Create a new `Surface` from a Xlib window handle.
    static Surface fromXlib(const(void)** display, c_ulong window) {
      return Surface(wgpu_create_surface_from_xlib(display, window));
    }
  }
}

version (D_Ddoc) {
  private WGPUSurfaceId wgpu_create_surface_from_android(void* a_native_window) { return 0; }
  private WGPUSurfaceId wgpu_create_surface_from_metal_layer(void* layer) { return 0; }
  private WGPUSurfaceId wgpu_create_surface_from_wayland(void* surface, void* display) { return 0; }
  private WGPUSurfaceId wgpu_create_surface_from_windows_hwnd(void* _hinstance, void* hwnd) { return 0; }
  private WGPUSurfaceId wgpu_create_surface_from_xlib(const void** _, ulong __) { return 0; }
}

/// A handle to a swap chain.
///
/// A `SwapChain` represents the image or series of images that will be presented to a `Surface`.
/// A `SwapChain` may be created with `Device.createSwapChain`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.SwapChain.html">wgpu::SwapChain</a>
struct SwapChain {
  /// Handle identifier.
  WgpuId id;
  /// Describes this `SwapChain.`
  SwapChainDescriptor descriptor;

  /// Returns the next texture to be presented by the swapchain for drawing.
  SwapChainOutput getNextTexture() {
    auto output = wgpu_swap_chain_get_next_texture(id);
    auto status = output.status.to!int.to!SwapChainStatus;
    auto successful = status == SwapChainStatus.good || status == SwapChainStatus.suboptimal;
    TextureView* view = null;
    if (successful) view = new TextureView(output.view_id);

    return SwapChainOutput(
      view,
      successful,
      status == SwapChainStatus.suboptimal,
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
  /// Describes this `Buffer`.
  BufferDescriptor descriptor;
  /// Result of a call to `Buffer.mapReadAsync` or `Buffer.mapWriteAsync`.
  BufferMapAsyncStatus status = BufferMapAsyncStatus.unknown;

  /// Release the given handle.
  void destroy() {
    if (id) wgpu_buffer_destroy(id);
    id = 0;
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
  /// Describes this `Texture`.
  TextureDescriptor descriptor;

  /// Release the given handle.
  void destroy() {
    if (id) wgpu_texture_destroy(id);
    id = 0;
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
  /// Describes this `Sampler`.
  SamplerDescriptor descriptor;
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
  /// Describes a `CommandBuffer`.
  const CommandBufferDescriptor descriptor;
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
  /// Describes a `CommandEncoder`.
  const CommandEncoderDescriptor descriptor;

  /// Finishes recording and returns a `CommandBuffer` that can be submitted for execution.
  CommandBuffer finish() {
    auto commandBufferDescriptor = CommandBufferDescriptor();
    return CommandBuffer(wgpu_command_encoder_finish(id, &commandBufferDescriptor), commandBufferDescriptor);
  }

  /// Begins recording of a render pass.
  ///
  /// This function returns a `RenderPass` object which records a single render pass.
  RenderPass beginRenderPass(const RenderPassDescriptor descriptor) {
    import std.algorithm.iteration : map;
    import std.array : array;

    auto colorAttachments = descriptor.colorAttachments.map!(attachment => {
      return WGPURenderPassColorAttachmentDescriptor(
        attachment.attachment,
        attachment.resolveTarget,
        WGPUPassChannel_Color(
          attachment.channel.loadOp,
          attachment.channel.storeOp,
          WGPUColor(
            attachment.channel.clearColor.r,
            attachment.channel.clearColor.g,
            attachment.channel.clearColor.b,
            attachment.channel.clearColor.a
          ),
          attachment.channel.readOnly
        )
      );
    }()).array;
    auto wgpuDescriptor = WGPURenderPassDescriptor(
      colorAttachments.ptr,
      descriptor.colorAttachments.length,
      descriptor.depthStencilAttachment
    );
    return RenderPass(wgpu_command_encoder_begin_render_pass(id, &wgpuDescriptor));
  }

  /// Begins recording of a compute pass.
  ///
  /// This function returns a `ComputePass` object which records a single compute pass.
  ComputePass beginComputePass(const ComputePassDescriptor descriptor) {
    return ComputePass(wgpu_command_encoder_begin_compute_pass(id, &descriptor));
  }

  /// Copy data from a texture to a buffer.
  void copyTextureToBuffer(const TextureCopyView source, const BufferCopyView destination, Extent3d copySize) {
    const source_ = WGPUTextureCopyView(
      source.texture,
      source.mipLevel,
      WGPUOrigin3d(source.origin.x, source.origin.y, source.origin.z)
    );
    wgpu_command_encoder_copy_texture_to_buffer(id, &source_, &destination, &copySize);
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
  /// Describes this `BindGroup`.
  BindGroupDescriptor descriptor;
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
  /// Describes this `BindGroupLayout`.
  BindGroupLayoutDescriptor descriptor;
}

/// An opaque handle to a pipeline layout.
///
/// A `PipelineLayout` object describes the available binding groups of a pipeline.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.PipelineLayout.html">wgpu::PipelineLayout</a>
struct PipelineLayout {
  /// Handle identifier.
  WgpuId id;
  /// Describes this `PipelineLayout`.
  PipelineLayoutDescriptor descriptor;
}

/// A handle to a rendering (graphics) pipeline.
///
/// A `RenderPipeline` object represents a graphics pipeline and its stages, bindings, vertex buffers and targets.
/// A `RenderPipeline` may be created with `Device.createRenderPipeline`.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPipeline.html">wgpu::RenderPipeline</a>
struct RenderPipeline {
  /// Handle identifier.
  WgpuId id;
  /// Describes this `RenderPipeline`.
  RenderPipelineDescriptor descriptor;

  /// Release the given handle.
  void destroy() {
    if (id) wgpu_render_pipeline_destroy(id);
    id = 0;
  }
}

/// An in-progress recording of a render pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.RenderPass.html">wgpu::RenderPass</a>
struct RenderPass {
  import std.typecons : Tuple;

  package WGPURenderPass* instance;
  /// Describes this `RenderPass`.
  RenderPassDescriptor descriptor;

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
    const wgpuColor = WGPUColor(color.r, color.g, color.b, color.a);
    wgpu_render_pass_set_blend_color(instance, &wgpuColor);
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
  /// Describes this `ComputePipeline`.
  ComputePipelineDescriptor descriptor;

  // TODO: Wait for fix: https://github.com/gecko0307/bindbc-wgpu/issues/7
  /// Release the given handle.
  // void destroy() {
  //   if (id) wgpu_compute_pipeline_destroy(id);
  //   id = 0;
  // }
}

/// An in-progress recording of a compute pass.
/// See_Also: <a href="https://docs.rs/wgpu/0.6.0/wgpu/struct.ComputePass.html">wgpu::ComputePass</a>
struct ComputePass {
  package WGPUComputePass* instance;
  /// Describes this `ComputePass`.
  ComputePassDescriptor descriptor;

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
