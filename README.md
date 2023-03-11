# wgpu-d

[![DUB Package](https://img.shields.io/dub/v/wgpu-d.svg)](https://code.dlang.org/packages/wgpu-d)
![wgpu-d CI](https://github.com/chances/wgpu-d/workflows/wgpu-d%20CI/badge.svg)

D bindings to [wgpu-native](https://github.com/gfx-rs/wgpu-native) as an idiomatic wrapper around the library.

Targets wgpu-native [`v0.10.4.1`](https://github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1).

## Usage

```json
"dependencies": {
    "wgpu-d": "0.1.2"
}
```

### Examples

You can try the examples before installing:

#### Headless

`dub run wgpu-d:headless`

#### Triangle

`dub run wgpu-d:triangle`

#### Cube

`dub run wgpu-d:cube`

## Development

Bindings to [`wgpu.h`](https://github.com/gfx-rs/wgpu-native/tree/v0.10.4.1/ffi) are generated dynamically on your host system and loaded by D with [ImportC](https://dlang.org/spec/importc.html). See the [`wgpu`](https://github.com/chances/wgpu-d/blob/v0.1.0/Makefile#L31-L39) Makefile task. The `wgpu` task is automatically performed as a Dub [pre-generate command](https://github.com/chances/wgpu-d/blob/v0.1.0/dub.json#L46).

### Testing

The unit test executable is patched (`patchelf` for Posix and `install_name_tool` for mac OS) to correct the library load path such that `libwgpu` is found.

See this [StackOverflow answer](https://stackoverflow.com/a/54723461/1363247).

### Upgrading wgpu-native

1. `make clean`
2. Bump the version constraint in [subprojects/wgpu.Makefile](https://github.com/chances/wgpu-d/blob/master/subprojects/wgpu.Makefile#L1).
3. `dub test`
4. Ensure the examples compile:
    - `dub build wgpu-d:headless`
    - `dub build wgpu-d:triangle`
    - `dub build wgpu-d:cube`
5. Fix any errors in the idiomatic wrapper
