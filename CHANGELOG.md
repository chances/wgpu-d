<!-- https://keepachangelog.com/en/1.0.0/ -->
# Changelog

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
