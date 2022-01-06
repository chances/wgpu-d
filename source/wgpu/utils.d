/// Utility structures and functions.
///
/// Loosely modelled after <a href="https://docs.rs/wgpu/0.10.2/wgpu/util/index.html">wgpu::util</a>.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/util/index.html">wgpu::util</a>
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2022 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.utils;

import wgpu.api : Buffer, Device, SwapChain, Texture, TextureDimension, TextureViewDimension;

/// Integral type used for buffer offsets.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/type.BufferAddress.html">wgpu::BufferAddress</a>
alias BufferAddress = ulong;
/// Slice into a `wgpu.api.Buffer`.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/type.BufferSlice.html">wgpu::BufferSlice</a>
alias BufferSlice = ubyte[];

// TODO: Implement DownloadBuffer? https://docs.rs/wgpu/0.10.2/wgpu/util/struct.DownloadBuffer.html
// TODO: Implement StagingBelt? https://docs.rs/wgpu/0.10.2/wgpu/util/struct.StagingBelt.html

/// Methods shared by `wgpu.api.RenderPass` and `wgpu.api.RenderBundleEncoder`.
interface RenderEncoder {
  import wgpu.api : BindGroup, IndexFormat, RenderPipeline, ShaderStage;

  void setBindGroup(uint index, BindGroup bindGroup, uint[] offsets);
  void setPipeline(RenderPipeline pipeline);
  void setIndexBuffer(BufferSlice bufferSlice, IndexFormat indexFormat);
  void setVertexBuffer(uint slot, BufferSlice bufferSlice);
  void draw(uint[] vertices, uint[] instances);
  void drawIndexed(uint[] indices, uint baseVertex, uint[] instances);
  void drawIndirect(Buffer indirectBuffer, ulong indirectOffset);
  void drawIndexedIndirect(Buffer indirectBuffer, ulong indirectOffset);
  void setPushConstants(ShaderStage stages, uint offset, ubyte[] data);
}

/// Convert the given texture `dimension` into a texture view dimension.
TextureViewDimension viewDimension(const TextureDimension dimension, uint depthOrArrayLayers = 1) {
  assert(depthOrArrayLayers > 0);
  final switch (dimension) {
    case TextureDimension._1D: return TextureViewDimension._1D;
    case TextureDimension._2D:
      if (depthOrArrayLayers > 1) return TextureViewDimension._2DArray;
      return TextureViewDimension._2D;
    // TODO: What of `.cube` and `.cubeArray`?
    case TextureDimension._3D: return TextureViewDimension._3D;
    case TextureDimension.force32: return TextureViewDimension.undefined;
  }
}

/// Detects whether `T` is a handle to a `wgpu`-managed resource.
enum isResource(T) = isMemberPointer!(T, "id");

private template isMemberPointer(T, alias string name) {
  import std.traits : isPointer;

  static foreach (member; __traits(allMembers, T)) {
    static if (member == name && isPointer!(typeof(__traits(getMember, T, member))))
      enum isMemberPointer = true;
  }
  static if (!is(typeof(isMemberPointer) == bool)) enum isMemberPointer = false;
}

/// Whether a handle to a `wgpu`-managed `resource` is valid, i.e. `resource` is not `null` and it's currently initialized.
bool valid(T)(T resource) if (isResource!T) {
  import std.traits : isPointer, PointerTarget;
  if ((isPointer!T || is (T == class)) && resource is null) return false;
  return resource.id !is null;
}

/// Recreates a new swap chain given an `extant` swap chain and a new size.
///
/// Usually called as the result of a swap chain's underlying `wgpu.api.Surface` having been resized, e.g. the user resized your app's window.
SwapChain resize(const SwapChain extant, Device device, uint width, uint height) @trusted {
  import wgpu.api : PresentMode, TextureFormat, TextureUsage;

  assert(extant.valid, "Extant swap chain is invalid");
  return device.createSwapChain(
    extant.surface, width, height,
    cast(const TextureFormat) extant.descriptor.format, cast(const TextureUsage) extant.descriptor.usage,
    cast(const PresentMode) extant.descriptor.presentMode, extant.label
  );
}

/// Recreates a new texture given an `extant` texture and a new size.
/// Remarks: Be aware this operation does $(B not) copy any data from the `extant` texture.
Texture resize(Texture extant, Device device, uint width, uint height) @trusted {
  import wgpu.api : TextureDimension, TextureFormat, TextureUsage;

  assert(extant.valid, "Extant texture is invalid");
  const descriptor = extant.descriptor;
  return device.createTexture(
    width, height,
    cast(TextureFormat) descriptor.format, cast(TextureUsage) descriptor.usage,
    cast(TextureDimension) descriptor.dimension,
    descriptor.mipLevelCount, descriptor.sampleCount, descriptor.size.depthOrArrayLayers,
  );
}

/// Recreates a new buffer given an `extant` buffer and a new size.
/// Remarks: Be aware this operation does $(B not) copy any data from the `extant` buffer.
Buffer resize(Buffer extant, Device device, uint size) @trusted {
  import std.conv : to;
  import std.typecons : Flag;
  import wgpu.api : BufferUsage;

  assert(extant.valid, "Extant buffer is invalid");
  const descriptor = extant.descriptor;
  return device.createBuffer(
    cast(BufferUsage) descriptor.usage, size,
    descriptor.mappedAtCreation.to!(Flag!"mappedAtCreation"),
    extant.label
  );
}
