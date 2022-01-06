# wgpu-d

[![DUB Package](https://img.shields.io/dub/v/wgpu-d.svg)](https://code.dlang.org/packages/wgpu-d)
![wgpu-d CI](https://github.com/chances/wgpu-d/workflows/wgpu-d%20CI/badge.svg)

D bindings to [wgpu-native](https://github.com/gfx-rs/wgpu-native) as an idiomatic wrapper around the library.

Targets wgpu-native [`v0.10.4.1`](https://github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1).

## Usage

```json
"dependencies": {
    "wgpu-d": "0.1.0"
}
```

### Examples

You can try the examples before installing:

#### Headless

`dub run wgpu-d:headless`

#### Triangle

`dub run wgpu-d:triangle`
