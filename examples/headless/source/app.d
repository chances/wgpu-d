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

  // The render pipeline renders data into this texture
  auto texture = device.createTexture(
    width, height,
    TextureFormat.rgba8UnormSrgb,
    TextureUsage.renderAttachment | TextureUsage.copySrc,
  );

  // The output buffer lets us retrieve data as an array
  auto outputBuffer = device.createBuffer(
    BufferUsage.mapRead | BufferUsage.copyDst,
    texture.paddedBytesPerRow * texture.height
  );

  // Set the background to red
  auto encoder = device.createCommandEncoder();
  auto renderPass = encoder.beginRenderPass(
    RenderPass.colorAttachment(texture.defaultView, LoadOp.clear, /* Red */ Color(1, 0, 0, 1))
  );
  renderPass.end();

  // Copy the data from the texture to the buffer
  encoder.copyTextureToBuffer(texture, outputBuffer);

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
  auto data = paddedBuffer.chunks(texture.paddedBytesPerRow)
    .map!(paddedRow => paddedRow[0 .. texture.bytesPerRow]).joiner.array;

  import imageformats : ColFmt, write_image;
  write_image("bin/headless.png", width, height, data, ColFmt.RGBA);

  outputBuffer.unmap();
  outputBuffer.destroy();
}
