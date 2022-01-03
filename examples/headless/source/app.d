import std.stdio;

import wgpu.api;

void main()
{
  // Adapted from https://github.com/rukai/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs
  writeln("Headless (windowless) Example");

  auto adapter = Instance.requestAdapter(null, PowerPreference.lowPower);
  assert(adapter !is null, "Adapter instance was not initialized");

  assert(adapter.ready, "Adapter is not ready");
  writefln("Adapter properties: %s", adapter.properties);
  writefln("Adapter limits: %s", adapter.limits);

  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready");
  writefln("Device limits: %s", device.limits);

  const width = 400;
  const height = 300;

  // https://github.com/rukai/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs#L53
  const bytesPerPixel = uint.sizeof;
  const unpaddedBytesPerRow = width * bytesPerPixel;
  const alignment = COPY_BYTES_PER_ROW_ALIGNMENT;
  const paddedBytesPerRowPadding = (alignment - unpaddedBytesPerRow % alignment) % alignment;
  const paddedBytesPerRow = unpaddedBytesPerRow + paddedBytesPerRowPadding;

  // The output buffer lets us retrieve data as an array
  auto outputBuffer = device.createBuffer(BufferDescriptor(
    null,
    null,
    BufferUsage.mapRead | BufferUsage.copyDst,
    paddedBytesPerRow * height,
    false
  ));

  // The render pipeline renders data into this texture
  auto textureExtent = Extent3d(width, height, 1);
  auto texture = device.createTexture(TextureDescriptor(
    null,
    null,
    TextureUsage.renderAttachment | TextureUsage.copySrc,
    TextureDimension._2D,
    textureExtent,
    TextureFormat.rgba8UnormSrgb,
    1, // Mip level count
    1, // Sample count
  ));
  auto textureView = texture.createDefaultView();

  // Set the background to red
  auto encoder = device.createCommandEncoder(CommandEncoderDescriptor());
  auto colorAttachment = RenderPassColorAttachment(
    textureView.id,
    null, // Resolve target
    LoadOp.clear,
    StoreOp.store,
    Color(1, 0, 0, 1), // Red
  );
  auto renderPass = encoder.beginRenderPass(RenderPassDescriptor(
    null,
    null,
    1,
    &colorAttachment,
    null, // depth stencil attachment
    null // occlusion query set
  ));
  renderPass.end();
  // Copy the data from the texture to the buffer
  encoder.copyTextureToBuffer(
    ImageCopyTexture(
      null,
      texture.id,
      0, // Mip level
      Origin3d(0, 0, 0),
      TextureAspect.all
    ),
    ImageCopyBuffer(
      null,
      TextureDataLayout(
        null,
        0, // Offset
        paddedBytesPerRow, // Bytes per row
        0 // Rows per image
      ),
      outputBuffer.id,
    ),
    textureExtent
  );

  auto commandBuffer = encoder.finish();
  device.queue.submit(commandBuffer);

  // Request a slice of the buffer
  outputBuffer.mapReadAsync(0, outputBuffer.descriptor.size);

  import std.typecons : Yes;
  device.poll(Yes.forceWait); // Force wait for a frame to render and pump callbacks

  auto paddedBuffer = outputBuffer.getMappedRange(0, outputBuffer.descriptor.size);

  import std.algorithm.iteration : map, joiner;
  import std.array : array;
  import std.range : chunks;
  auto data = paddedBuffer.chunks(paddedBytesPerRow)
    .map!(paddedRow => paddedRow[0 .. unpaddedBytesPerRow]).joiner.array;

  import imageformats : ColFmt, write_image;
  write_image("bin/headless.png", width, height, data, ColFmt.RGBA);

  outputBuffer.unmap();
  outputBuffer.destroy();
}
