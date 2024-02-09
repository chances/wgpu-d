import std.conv : to;
import std.math : floor;
import std.stdio;

import bindbc.glfw;
import wgpu.api;

package:

version (OSX) enum SUPPORTED_TARGET = true;
version (Linux) enum SUPPORTED_TARGET = true;
version (Windows) enum SUPPORTED_TARGET = true;
static if (!__traits(compiles, SUPPORTED_TARGET)) enum SUPPORTED_TARGET = false;
static assert(SUPPORTED_TARGET, "Unsupported target platform");

string lastError = null;
extern(C) void wgpu_glfw_error_callback(int error, const char* description) nothrow {
  import std.conv : ConvException;
  import std.exception : assertNotThrown, assumeWontThrow, ifThrown;
  import std.string : fromStringz;

  if (description is null) stderr.writefln("GLFW Error %d", error).assumeWontThrow;
  else {
    stderr.writefln("GLFW Error %d: %s", error, description).assumeWontThrow;
    lastError = description.fromStringz.to!string.ifThrown!ConvException(null).assumeWontThrow;
  }
}

enum string triangleShader = `@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> @builtin(position) vec4f {
  let x = f32(i32(in_vertex_index) - 1);
  let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
  return vec4f(x, y, 0.0, 1.0);
}

@fragment
fn fs_main() -> @location(0) vec4f {
  return vec4f(1.0, 0.0, 0.0, 1.0);
}`;
enum string fullScreenQuadShader = `struct VertexOutput {
  @builtin(position) clip_position: vec4f;
  @location(0) tex_coords: vec2f;
};

@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> VertexOutput {
  let x = f32(i32(in_vertex_index) - 1);
  let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
  return VertexOutput(vec4f(x, y, 0.0, 1.0), vec2f(x, y));
}

@group(0) @binding(0)
var diffuse: texture_2d<f32>;
@group(0) @binding(1)
var diffuseSampler: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
  return textureSample(diffuse, diffuseSampler, in.tex_coords);
}`;

// Adapted from https://github.com/gfx-rs/wgpu-native/blob/v0.10.4.1/examples/triangle/main.c
// See also https://sotrh.github.io/learn-wgpu/beginner/tutorial5-textures
void main() {
  import std.exception : enforce;
  import std.functional : toDelegate;
  import std.string : toStringz;
  import std.typecons : Yes;

  // Create GLFW window

  const title = "Triangle Example";
  title.writeln;

  glfwSetErrorCallback(&wgpu_glfw_error_callback);
  assert(glfwInit(), "GLFW was not initialized");

  // https://www.glfw.org/docs/3.3/window_guide.html#window_hints
  glfwWindowHint(GLFW_VISIBLE, false);
  glfwWindowHint(GLFW_RESIZABLE, true);
  glfwWindowHint(GLFW_FOCUSED, true);
  glfwWindowHint(GLFW_FOCUS_ON_SHOW, true);
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API); // Graphics are handled by WebGPU

  const width = 640;
  const height = 480;
  auto window = glfwCreateWindow(width, height, title.toStringz, null, null);
  assert(window !is null, "Could not create window:\n\t" ~ lastError);
  glfwSetWindowSizeLimits(window, 640, 480, GLFW_DONT_CARE, GLFW_DONT_CARE);

  // Create WebGPU resources

  auto instance = Instance.create();
  assert(instance.id, "Could not create WebGPU instance.");

  Surface surface;
  version (OSX) {
    auto nativeWindow = NSWindow.from(glfwGetCocoaWindow(window).enforce, lastError);
    auto metalLayer = CAMetalLayer.classOf.layer;
    nativeWindow.contentView.wantsLayer = true;
    nativeWindow.contentView.layer = metalLayer;
    surface = Surface.fromMetalLayer(instance, metalLayer.asId);
  }
  version (Linux) {
    surface = Surface.fromXlib(instance, glfwGetX11Display().enforce, glfwGetX11Window(window).enforce.to!uint);
  }
  version (Windows) {
    import core.sys.windows.windows : GetModuleHandleA;
    surface = Surface.fromWindowsHwnd(instance, GetModuleHandleA(null), glfwGetWin32Window(window));
  }
  assert(surface.id !is null, "Could not create native surface");

  auto adapter = instance.requestAdapter(surface, PowerPreference.lowPower);
  assert(adapter.ready, "Adapter instance was not initialized");

  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready");

  auto swapChainFormat = surface.preferredFormat(adapter);
  auto swapChain = device.createSwapChain(
    surface, width, height, swapChainFormat,
    // TODO: Remove this redundant texture usage parameter
    TextureUsage.renderAttachment,
    PresentMode.fifo,
    title
  );

  // The render pipeline renders data into this texture
  auto texture = device.createTexture(
    width, height,
    swapChainFormat,
    TextureUsage.renderAttachment | TextureUsage.copySrc | TextureUsage.textureBinding,
  );

  RenderPipeline createPipeline(
    string shaderSource, PipelineLayout layout, MultisampleState multisample, ColorTargetState[] renderTargets
  ) {
    auto shader = device.createShaderModule(shaderSource);
    return device.createRenderPipeline(
      layout,
      VertexState(shader, "vs_main"),
      PrimitiveState(PrimitiveTopology.triangleList, IndexFormat.undefined, FrontFace.ccw, CullMode.none),
      multisample,
      new FragmentState(shader, "fs_main", renderTargets),
    );
  }
  auto trianglePipeline = createPipeline(triangleShader, device.emptyPipelineLayout, texture.multisampleState, [
    texture.asRenderTarget(BlendMode.replace)
  ]);

  // The output buffer lets us retrieve data as an array
  auto outputBuffer = device.createBuffer(
    BufferUsage.mapRead | BufferUsage.copyDst,
    texture.paddedBytesPerRow * texture.height
  );

  void resizeRenderTargets() {
    import wgpu.utils : resize;

    assert(device.ready);

    int w, h;
    glfwGetFramebufferSize(window, &w, &h);
    const width = w.to!uint;
    const height = h.to!uint;

    // Resize render targets and then destroy the old ones
    auto extantSwapChain = swapChain;
    swapChain = swapChain.resize(device, width, height);
    extantSwapChain.destroy();
    // FIXME: auto extantTexture = texture; extantTexture.destroy();
    texture = texture.resize(device, width, height);
    auto extantOutputBuffer = outputBuffer;
    outputBuffer = outputBuffer.resize(device, texture.paddedBytesPerRow * texture.height);
    extantOutputBuffer.destroy();
  }

  // Defer render target resizing until _after_ the current queue has finished.
  // This protects against cases where the framebuffer was resized during command recording
  alias FutureTask = void delegate();
  FutureTask[] futureTasks;

  glfwSetFramebufferSizeCallback(window, bindDelegate((GLFWwindow*, int, int) nothrow {
    futureTasks ~= &resizeRenderTargets;
  }.toDelegate));

  bool paused = false;
  glfwSetWindowIconifyCallback(window, ((GLFWwindow*, int iconified) nothrow {
    paused = iconified != 0;
  }).toDelegate.bindDelegate);

  double elapsedTime = 0;
  const uint desiredFps = 60;
  /// Approximate measure of the current FPS.
  double currentFps = 0;
  auto controls = "Press ESC to quit, P to capture framebuffer";
  auto captureFrame = false;

  glfwShowWindow(window);
  while (!glfwWindowShouldClose(window)) {
    import std.exception : enforce;
    import std.math : abs;
    import std.string : format;

    while (paused) glfwWaitEventsTimeout(0.25 / 2);

    const currentTime = enforce(glfwGetTime(), lastError);
    auto frameTime = elapsedTime - currentTime;
    currentFps = (1 / frameTime).abs;
    auto desiredFrameTime = 1 / desiredFps.to!double;
    elapsedTime = currentTime;

    glfwWaitEventsTimeout(frameTime < (desiredFrameTime * 0.5) ? desiredFrameTime * 0.5 : 0);
    auto frameStatistics = currentFps < 1
      ? format!"<1 FPS @ %5.2fsec"(frameTime)
      : format!"%2d FPS @ %6.2fms"(currentFps.floor.to!ulong, frameTime.ms);
    glfwSetWindowTitle(window, format!"%s - %s - %s"(title, controls, frameStatistics).toStringz);

    // Update

    if (glfwGetKey(window, GLFW_KEY_ESC) == GLFW_PRESS) break;
    captureFrame = glfwGetKey(window, GLFW_KEY_P) == GLFW_PRESS;
    if (futureTasks.length) {
      foreach (task; futureTasks) task();
      futureTasks = [];
    }

    // Render

    auto swapChainTexture = swapChain.getNextTexture();

    // Render a triangle
    auto encoder = device.createCommandEncoder();
    auto renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(texture.defaultView, /* Transparent Black */ Color(0, 0, 0, 0))
    );
    renderPass.setPipeline(trianglePipeline);
    renderPass.draw(3, 1);
    renderPass.end();

    // Copy the data from the texture to the buffer
    if (captureFrame) encoder.copyTextureToBuffer(texture, outputBuffer);

    // Blit to swap chain
    renderPass = encoder.beginRenderPass(
      RenderPass.colorAttachment(swapChainTexture, /* Black */ Color(0, 0, 0, 1))
    );
    renderPass.setPipeline(trianglePipeline);
    renderPass.draw(3, 1);
    renderPass.end();

    auto commandBuffer = encoder.finish();
    device.queue.submit(commandBuffer);
    swapChain.present();

    // Request a slice of the output buffer
    if (captureFrame) outputBuffer.mapReadAsync(0, outputBuffer.descriptor.size);

    // Force wait for a frame to render and pump callbacks
    device.poll(Yes.forceWait);

    if (!captureFrame) continue;

    auto paddedBuffer = outputBuffer.getMappedRange(0, outputBuffer.descriptor.size);

    import std.algorithm.iteration : map, joiner;
    import std.array : array;
    import std.range : chunks;
    auto data = paddedBuffer.chunks(texture.paddedBytesPerRow)
      .map!(paddedRow => paddedRow[0 .. texture.bytesPerRow]).joiner.array;

    // TODO: Switch to https://code.dlang.org/packages/imagefmt
    import imageformats : ColFmt, write_image;
    write_image("bin/triangle.png", width, height, data, ColFmt.RGBA);
    captureFrame = false;

    outputBuffer.unmap();
  }

  outputBuffer.destroy();

  glfwTerminate();
}

import std.traits : isDelegate, isImplicitlyConvertible;

/// Convert `value`, in seconds, to milliseconds.
/// Returns: `value` converted to milliseconds, rounded down to to the nearest positive integer.
/// If the conversion overflows, zero is returned.
ulong ms(T)(T value) nothrow if (isImplicitlyConvertible!(T, real)) {
  import std.conv : ConvOverflowException;
  import std.exception : assumeWontThrow, ifThrown;
  return (value / 1000).floor.to!ulong.ifThrown!ConvOverflowException(0).assumeWontThrow;
}

/// Transform the given delegate into a static function pointer with C linkage.
/// See_Also: <a href="https://stackoverflow.com/a/22845722/1363247">stackoverflow.com/a/22845722/1363247</a>
auto bindDelegate(Func, string file = __FILE__, size_t line = __LINE__)(Func f) if(isDelegate!Func) {
  import std.traits : ParameterTypeTuple, ReturnType;

  static Func delegate_;
  delegate_ = f;
  extern(C) static ReturnType!Func func(ParameterTypeTuple!Func args) {
    return delegate_(args);
  }

  return &func;
}

version (Windows) {
  import core.sys.windows.windows : HWND;
  // FIXME: Undefined return types: https://github.com/BindBC/bindbc-glfw/blob/6529ce4f67f69839a93de5e0bbe1150fab30d633/source/bindbc/glfw/bindstatic.d#L172
  extern(C) @nogc nothrow HWND glfwGetWin32Window(GLFWwindow* window);
	extern(C) @nogc nothrow const(char)* glfwGetWin32Adapter(GLFWmonitor* monitor);
	extern(C) @nogc nothrow const(char)* glfwGetWin32Monitor(GLFWmonitor* monitor);
}

version (Linux) {
  // FIXME: Undefined return types: https://github.com/BindBC/bindbc-glfw/blob/6529ce4f67f69839a93de5e0bbe1150fab30d633/source/bindbc/glfw/bindstatic.d#L223
  extern(C) @nogc nothrow {
    void* glfwGetX11Display();
    ulong glfwGetX11Window(GLFWwindow* window);
    ulong glfwGetX11Adapter(GLFWmonitor* monitor);
    ulong glfwGetX11Monitor(GLFWmonitor* monitor);
    void glfwSetX11SelectionString(const(char)* string_);
    const(char)* glfwGetX11SelectionString();
  }
}

// mac OS interop with the Objective-C Runtime
version (OSX) {
  import core.attribute : selector;

  alias id = void*;

  alias CGDirectDisplayID = uint;
  mixin(bindGLFW_Cocoa);

  // Objective-C Runtime
  // https://developer.apple.com/documentation/objectivec/1418952-objc_getclass?language=objc
  extern (C) id objc_getClass(const(char)* name);

  /// Detect whether `T` is the `NSObject` interface.
  enum bool isNSObject(T) = __traits(isSame, T, NSObject);

  /// Converts an instance of `NSObject` to an `id`.
  id asId(NSObject obj) @trusted {
    return cast(id) obj;
  }

  extern (Objective-C):

  interface NSObject {
    import std.meta : anySatisfy;
    import std.traits : InterfacesTuple;

    extern (D) static T classOf(T)() @trusted if (anySatisfy!(isNSObject, InterfacesTuple!T)) {
      enum name = __traits(identifier, T);
			auto cls = cast(T) objc_getClass(name);
			assert(cls, "Failed to lookup Obj-C class: " ~ name);
			return cls;
		}

    extern (D) static T from(T)(id obj) @trusted if (anySatisfy!(isNSObject, InterfacesTuple!T)) {
      assert(obj !is null);
      return cast(T) obj;
    }
  }

  // https://developer.apple.com/documentation/quartzcore/calayer?language=objc
  interface CALayer : NSObject {}
  // https://developer.apple.com/documentation/quartzcore/cametallayer?language=objc
  interface CAMetalLayer : CALayer {
    CAMetalLayer layer() @selector("layer");

    extern (D) final static CAMetalLayer classOf() @trusted {
      return NSObject.classOf!CAMetalLayer;
		}
  }

  // https://developer.apple.com/documentation/appkit/nsview?language=objc
  interface NSView : NSObject {
    void wantsLayer(bool wantsLayer) @selector("setWantsLayer:");
    CALayer layer() @selector("layer");
    void layer(CALayer layer) @selector("setLayer:");
  }

  // https://developer.apple.com/documentation/appkit/nswindow?language=objc
  interface NSWindow : NSObject {
    // https://developer.apple.com/documentation/appkit/nswindow/1419160-contentview?language=objc
    NSView contentView() @selector("contentView");

    extern (D) final static NSWindow from(id obj) {
      return NSObject.from!NSWindow(obj);
    }
  }
}
