import std.stdio;

import wgpu.api;

void main()
{
  // Adapted from https://github.com/rukai/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs
  writeln("Headless (windowless) Example");

	auto adapter = Adapter(RequestAdapterOptions(PowerPreference.Default));

  assert(adapter.ready, "Adapter is not ready");
  writefln("Adapter info: %s", adapter.info);
  writefln("Adapter limits: %s", adapter.limits);

  auto device = adapter.requestDevice(Limits());
  writefln("Device limits: %s", device.limits);

  const width = 300;
  const height = 400;

  // https://github.com/rukai/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs#L53
  const bytesPerPixel = uint.sizeof;
  const unpaddedBytesPerRow = width * bytesPerPixel;
  const alignment = COPY_BYTES_PER_ROW_ALIGNMENT;
  const paddedBytesPerRowPadding = (alignment - unpaddedBytesPerRow % alignment) % alignment;
  const paddedBytesPerRow = unpaddedBytesPerRow + paddedBytesPerRowPadding;

  // The output buffer lets us retrieve data as an array
  auto outputBuffer = device.createBuffer(BufferDescriptor(
    null,
    paddedBytesPerRow * height,
    BufferUsage.mapRead | BufferUsage.copyDst,
    false
  ));

  // The render pipeline renders data into this texture
  auto textureExtent = Extent3d(width, height, 1);
  auto texture = device.createTexture(TextureDescriptor(
    null,
    textureExtent,
    1, // Mip level count
    1, // Sample count
    TextureDimension.D2,
    TextureFormat.Rgba8UnormSrgb,
    TextureUsage.outputAttachment | TextureUsage.copySrc,
  ));
  auto textureView = texture.createDefaultView();

  // Set the background to red
  auto encoder = device.createCommandEncoder(CommandEncoderDescriptor());
  auto colorAttachment = RenderPassColorAttachmentDescriptor(
    textureView.id,
    0, // Resolve target
    PassChannel_Color(
      LoadOp.Clear,
      StoreOp.Store,
      Color(1, 0, 0, 1), // Red
      false // Is *not* read only
    )
  );

  encoder.beginRenderPass(RenderPassDescriptor(
    &colorAttachment,
    1,
    null // depth stencil attachment
  ));
  // Copy the data from the texture to the buffer
  encoder.copyTextureToBuffer(
    TextureCopyView(
      texture.id,
      0, // Mip level
      Origin3d(0, 0, 0),
    ),
    BufferCopyView(
      outputBuffer.id,
      TextureDataLayout(
        0, // Offset
        paddedBytesPerRow, // Bytes per row
        0 // Rows per image
      ),
    ),
    textureExtent
  );
  auto commandBuffer = encoder.finish();
  device.queue.submit(commandBuffer);

  device.poll(true); // Force wait for a frame to render

  // TODO: Write a bmp or png of the output

  outputBuffer.unmap();
}
