<!-- https://keepachangelog.com/en/1.0.0/ -->
# Changelog

## v0.1.0

Add a windowed triangle example.

### Added

- [`wgpu.utils`](https://chances.github.io/wgpu-d/wgpu/utils.html) module of structures and functions, loosely modelled after [`wgpu::util`](https://docs.rs/wgpu/0.10.2/wgpu/util/index.html).
- [`BlendMode`](https://chances.github.io/wgpu-d/wgpu/api/BlendMode.html) enum
- [`MultisampleState`](https://chances.github.io/wgpu-d/wgpu/api/MultisampleState.html) struct
- [`PrimitiveState`](https://chances.github.io/wgpu-d/wgpu/api/PrimitiveState.html) struct
- [`DepthStencilState`](https://chances.github.io/wgpu-d/wgpu/api/DepthStencilState.html) struct
- [`ColorTargetState`](https://chances.github.io/wgpu-d/wgpu/api/ColorTargetState.html) struct
- [`VertexState`](https://chances.github.io/wgpu-d/wgpu/api/VertexState.html) struct
- [`FragmentState`](https://chances.github.io/wgpu-d/wgpu/api/FragmentState.html) class
- `Device.createShaderModule(string wgsl)` method overload
- [`Device.createBindGroupLayout`](https://chances.github.io/wgpu-d/wgpu/api/Device.createBindGroupLayout.html) method
- `Device.createBindGroup(BindGroupLayout layout, BindGroupEntry[] entries, string label = null)` method overload
- [`Device.emptyPipelineLayout`](https://chances.github.io/wgpu-d/wgpu/api/Device.emptyPipelineLayout.html) method
- `Device.createPipelineLayout(const BindGroupLayout[] bindGroups, string label = null)` method overload
- `createSampler(AddressMode addressMode, FilterMode magFilter, FilterMode minFilter, FilterMode mipmapFilter = FilterMode.nearest)` method overload
- `Device.createSwapChain(const Surface surface, uint width, uint height, const TextureFormat format, const TextureUsage usage, const PresentMode presentMode, const string label = null)` method overload
- [`Texture.asRenderTarget`](https://chances.github.io/wgpu-d/wgpu/api/Texture.asRenderTarget.html) method
- [`Texture.multisampleState`](https://chances.github.io/wgpu-d/wgpu/api/Texture.multisampleState.html) method
- [`TextureView.textureSampler`](https://chances.github.io/wgpu-d/wgpu/api/TextureView.textureSampler.html) method
- [`TextureView.binding`](https://chances.github.io/wgpu-d/wgpu/api/TextureView.binding.html) method
- [`Sampler.binding`](https://chances.github.io/wgpu-d/wgpu/api/Sampler.binding.html) method
- [`CommandEncoder.copyBufferToTexture`](https://chances.github.io/wgpu-d/wgpu/api/CommandEncoder.copyBufferToTexture.html) method
- [`RenderPass.colorAttachment`](https://chances.github.io/wgpu-d/wgpu/api/RenderPass.colorAttachment.html) factory method
- `RenderPass.draw(uint vertexCount, uint instanceCount, uint firstVertex = 0, uint firstInstance = 0)` method overload

### Changed

- Enhance documentation
- Change signatures of and refactor `Instance.requestAdapter` and `Adapter.requestDevice`
- Refactor [`RenderPass.setBindGroup`](https://chances.github.io/wgpu-d/wgpu/api/RenderPass.setBindGroup.html) method signature
- Refactor [`Device.createRenderPipeline`](https://chances.github.io/wgpu-d/wgpu/api/Device.createRenderPipeline.html) method signatures
- Refactor [`Device.createTexture`](https://chances.github.io/wgpu-d/wgpu/api/Device.createTexture.html) method signatures
- Refactor `Device.createShaderModule(const byte[] spv)`
- Refactor `Device`, `Buffer`, `RenderPipeline`, and `SwapChain` into classes
    Because dealing with, "What if this debug label goes out of scope and gets GC'd?" is becoming a headache, convert offending `struct`ures (those with complex wrappers that aren't simply opaque pointers) to classes to reap those [reference semantics](https://forum.dlang.org/post/ixfpxfdmnahtytftwald@forum.dlang.org).
- Refactor [`Buffer.getMappedRange`](https://chances.github.io/wgpu-d/wgpu/api/Buffer.getMappedRange.html) method signature
- Refactor [`Buffer.mapReadAsync`](https://chances.github.io/wgpu-d/wgpu/api/Buffer.mapReadAsync.html) and [`Buffer.mapWriteAsync`](https://chances.github.io/wgpu-d/wgpu/api/Buffer.mapWriteAsync.html) method signatures
- Refactor [`Texture.defaultView`](https://chances.github.io/wgpu-d/wgpu/api/Texture.defaultView.html) property
- Refactor [`Surface`](https://chances.github.io/wgpu-d/wgpu/api/Surface.html) factory methods

### Fixed

- Refactor `Surface` factory methods' documentation
    Method docs were duplicated depending on the OS where docs were built.

## v0.1.0-alpha.3

Improve ergonomics of the idiomatic API.

### Added

- Method overloads for:
  - [`Device.createBuffer`](https://chances.github.io/wgpu-d/wgpu/api/Device.createBuffer.html)
  - [`Device.createCommandEncoder`](https://chances.github.io/wgpu-d/wgpu/api/Device.createCommandEncoder.html)
  - [`Device.createTexture`](https://chances.github.io/wgpu-d/wgpu/api/Device.createTexture.html)
  - [`CommandEncoder.beginRenderPass`](https://chances.github.io/wgpu-d/wgpu/api/CommandEncoder.beginRenderPass.html)
  - [`CommandEncoder.copyTextureToBuffer`](https://chances.github.io/wgpu-d/wgpu/api/CommandEncoder.copyTextureToBuffer.html)
- [`RenderPass.colorAttachment`](https://chances.github.io/wgpu-d/wgpu/api/RenderPass.colorAttachment.html) static initializer
- `wgpu.limits` utility [module](https://chances.github.io/wgpu-d/wgpu/limits.html) to help manage GPU limitations
- Properties to `Texture`, several of which are useful to maintain alignment with Texture-Buffer copies:
  - [`size`](https://chances.github.io/wgpu-d/wgpu/api/Texture.size.html)
  - [`width`](https://chances.github.io/wgpu-d/wgpu/api/Texture.width.html)
  - [`height`](https://chances.github.io/wgpu-d/wgpu/api/Texture.height.html)
  - [`bytesPerBlock`](https://chances.github.io/wgpu-d/wgpu/api/Texture.bytesPerBlock.html)
  - [`pixelsPerBlock`](https://chances.github.io/wgpu-d/wgpu/api/Texture.pixelsPerBlock.html)
  - [`bytesPerRow`](https://chances.github.io/wgpu-d/wgpu/api/Texture.bytesPerRow.html)
  - [`paddedBytesPerRow`](https://chances.github.io/wgpu-d/wgpu/api/Texture.paddedBytesPerRow.html)
  - [`asImageCopy`](https://chances.github.io/wgpu-d/wgpu/api/Texture.asImageCopy.html)
  - [`dataLayout`](https://chances.github.io/wgpu-d/wgpu/api/Texture.dataLayout.html)

## v0.1.0-alpha.2

Upgraded to [`wgpu-native`@0.10.4.1](https://github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1).

### Added

- [`RenderPass.end`](https://chances.github.io/wgpu-d/wgpu/api/RenderPass.end.html)
- [`RenderPass.setBlendConstant`](https://chances.github.io/wgpu-d/wgpu/api/RenderPass.setBlendConstant.html)

### Changed

- The method of binding to [wgpu-native](https://github.com/gfx-rs/wgpu-native) was switched from [`dpp`](https://github.com/atilaneves/dpp#readme) to [ImportC](https://dlang.org/spec/importc.html) ([#5](https://github.com/chances/wgpu-d/pull/5))

### Fixes

- Fix `Surface` static initializers for Linuxes

### Removed

- Removed Wayland support

## v0.1.0-alpha.1

- Add an idiomatic D wrapper around [wgpu-native](https://github.com/gfx-rs/wgpu-native)
- Add [generated documentation](https://chances.github.io/wgpu-d)
- Add a windowless example that clears the background to red
- Add `Surface` static initializers given native window pointers
- Add `Device.ready` property
- Add descriptor references to all describable structs
