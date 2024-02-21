/// Utility structures and functions.
///
/// Loosely modelled after <a href="https://docs.rs/wgpu/0.10.2/wgpu/util/index.html">wgpu::util</a>.
/// See_Also: <a href="https://docs.rs/wgpu/0.10.2/wgpu/util/index.html">wgpu::util</a>
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2022 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.utils;

import wgpu.api : Buffer, BufferUsage, Device, Texture, TextureDimension, TextureViewDimension;

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

  ///
  void setBindGroup(uint index, BindGroup bindGroup, uint[] offsets);
  ///
  void setPipeline(RenderPipeline pipeline);
  ///
  void setIndexBuffer(BufferSlice bufferSlice, IndexFormat indexFormat);
  ///
  void setVertexBuffer(uint slot, BufferSlice bufferSlice);
  ///
  void draw(uint[] vertices, uint[] instances);
  ///
  void drawIndexed(uint[] indices, uint baseVertex, uint[] instances);
  ///
  void drawIndirect(Buffer indirectBuffer, ulong indirectOffset);
  ///
  void drawIndexedIndirect(Buffer indirectBuffer, ulong indirectOffset);
  ///
  void setPushConstants(ShaderStage stages, uint offset, ubyte[] data);
}

/// Creates a buffer in which `data` is loaded.
/// See_Also:
/// $(UL
///   $(LI `Device.createBuffer` )
///   $(LI <a href="https://docs.rs/wgpu/0.10.2/wgpu/util/trait.DeviceExt.html#tymethod.create_buffer_init">DeviceExt::createBufferInit</a> )
/// )
Buffer createBuffer(const Device device, BufferUsage usage, ubyte[] data, string label = null) {
  import std.algorithm : copy;
  import std.conv : to;
  import std.typecons : No, Yes;
  import wgpu.api : COPY_BUFFER_ALIGNMENT;

  // Skip mapping if the buffer is empty
  if (data.length == 0) return device.createBuffer(usage, data.length.to!uint, label);

  const unpaddedSize = data.length;
  // Valid vulkan usage:
  // 1. buffer size must be a multiple of COPY_BUFFER_ALIGNMENT.
  // 2. buffer size must be greater than 0.
  // Therefore, size is rounded up to the nearest multiple of COPY_BUFFER_ALIGNMENT, where the multiple is at least one.
  const paddedSize = unpaddedSize + (unpaddedSize % COPY_BUFFER_ALIGNMENT);
  auto buffer = device.createBuffer(usage, paddedSize.to!uint, Yes.mappedAtCreation, label);

  // Copy data into buffer
  auto buf = buffer.getMappedRange(0, unpaddedSize);
  assert(data.copy(buf).length == 0, "Data was not copied into buffer evenly, i.e. buffer was not filled");
  buffer.unmap();

  return buffer;
}

/// Convert the given texture `dimension` into a texture view dimension.
TextureViewDimension viewDimension(const TextureDimension dimension, uint depthOrArrayLayers = 1) {
  assert(depthOrArrayLayers > 0);
  final switch (dimension) {
    case TextureDimension._1d: return TextureViewDimension._1d;
    case TextureDimension._2d:
      if (depthOrArrayLayers > 1) return TextureViewDimension._2dArray;
      return TextureViewDimension._2d;
    // TODO: What of `.cube` and `.cubeArray`?
    case TextureDimension._3d: return TextureViewDimension._3d;
    case TextureDimension.force32: return TextureViewDimension.undefined;
  }
}

unittest {
  assert(TextureDimension._1d.viewDimension == TextureViewDimension._1d);
  assert(TextureDimension._2d.viewDimension == TextureViewDimension._2d);
  assert(TextureDimension._2d.viewDimension(5) == TextureViewDimension._2dArray);
  assert(TextureDimension._3d.viewDimension == TextureViewDimension._3d);
  assert(TextureDimension.force32.viewDimension == TextureViewDimension.undefined);
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
  static if ((isPointer!T || is (T == class))) return resource !is null;
  else return resource.id !is null;
}

unittest {
  import wgpu.api : ShaderModule;
  assert(!valid(ShaderModule(null)));
}

/// Recreates a new texture given an `extant` texture and a new size.
/// Remarks: Be aware this operation does $(B not) copy any data from the `extant` texture.
Texture resize(Texture extant, const Device device, uint width, uint height) @trusted {
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
Buffer resize(Buffer extant, const Device device, uint size) @trusted {
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
