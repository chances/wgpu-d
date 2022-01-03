/// Utilities to help manage GPU limitations.
///
/// See_Also:
/// $(UL
///   $(LI `wgpu.api.Device` )
///   $(LI `wgpu.api.Adapter` )
/// )
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2020-2022 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.limits;

import wgpu.api : Limits;

/// The set of limits that is guaranteed to work on all modern backends and is guaranteed to be supported by WebGPU.
///
/// Applications needing more modern features can use this as a reasonable set of limits if they are targeting only desktop and modern mobile devices.
enum Limits defaultLimits = {
  // https://docs.rs/wgpu-types/0.10.0/src/wgpu_types/lib.rs.html#618
  maxTextureDimension1D: 8192,
  maxTextureDimension2D: 8192,
  maxTextureDimension3D: 2048,
  maxTextureArrayLayers: 2048,
  maxBindGroups: 4,
  maxDynamicUniformBuffersPerPipelineLayout: 8,
  maxDynamicStorageBuffersPerPipelineLayout: 4,
  maxSampledTexturesPerShaderStage: 16,
  maxSamplersPerShaderStage: 16,
  maxStorageBuffersPerShaderStage: 8,
  maxStorageTexturesPerShaderStage: 8,
  maxUniformBuffersPerShaderStage: 12,
  maxUniformBufferBindingSize: 16_384,
  maxStorageBufferBindingSize: 128 << 20,
  maxVertexBuffers: 8,
  maxVertexAttributes: 16,
  maxVertexBufferArrayStride: 2048,
  // TODO: maxPushConstantSize: 0,
};

/// The set of limits that are guaranteed to be compatible with GLES3, WebGL, and D3D11.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Limits.html#method.downlevel_defaults">wgpu::Limits.downlevel_defaults</a>
enum Limits downlevelDefaultLimits = {
  // https://docs.rs/wgpu-types/0.10.0/src/wgpu_types/lib.rs.html#644
  maxTextureDimension1D: 2096,
  maxTextureDimension2D: 2096,
  maxTextureDimension3D: 256,
  maxTextureArrayLayers: 256,
  maxBindGroups: 4,
  maxDynamicUniformBuffersPerPipelineLayout: 8,
  maxDynamicStorageBuffersPerPipelineLayout: 4,
  maxSampledTexturesPerShaderStage: 16,
  maxSamplersPerShaderStage: 16,
  maxStorageBuffersPerShaderStage: 4,
  maxStorageTexturesPerShaderStage: 4,
  maxUniformBuffersPerShaderStage: 12,
  maxUniformBufferBindingSize: 16_384,
  maxStorageBufferBindingSize: 128 << 20,
  maxVertexBuffers: 8,
  maxVertexAttributes: 16,
  maxVertexBufferArrayStride: 2048,
  // TODO: maxPushConstantSize: 0,
};

/// Modify the current limits to use the resolution limits of the other.
///
/// This is useful because the swap chain might need to be larger than any other image in the application.
/// For example, if your application only needs 512x512 textures, but it might be running on a 4k display.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/struct.Limits.html#method.using_resolution">wgpu::Limits.using_resolution</a>
Limits usingResolution(Limits target, Limits other) {
  target.maxTextureDimension1D = other.maxTextureDimension1D;
  target.maxTextureDimension2D = other.maxTextureDimension2D;
  target.maxTextureDimension3D = other.maxTextureDimension3D;
  return target;
}
