/// Authors: Chance Snow
/// Copyright: Copyright © 2023 Chance Snow. All rights reserved.
/// License: MIT License
module examples.math;

import std.math : PI;
import std.traits : isImplicitlyConvertible;

import gfm.math;

/// See_Also: https://github.com/gfx-rs/wgpu-rs/blob/6c60ca980d3cf09cc42c71fafb78f685eb5e6677/examples/framework.rs#L11
const openGlToWgpuCorrection = mat4f.fromRows([
  vec4f(1.0, 0.0, 0.0, 0.0),
  vec4f(0.0, 1.0, 0.0, 0.0),
  vec4f(0.0, 0.0, 0.5, 0.0),
  vec4f(0.0, 0.0, 0.5, 1.0),
]);

/// Convert `value`, in degrees, to radians.
/// Returns: `value` converted to radians.
T rad(T)(T value) nothrow if (isImplicitlyConvertible!(T, real)) {
  return value * (PI / 180);
}
