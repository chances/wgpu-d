/// Windowing utilities for WGPU D examples.
///
/// Loosely based on wgpu-native's <a href="https://github.com/gfx-rs/wgpu-native/blob/v0.10.4.1/examples/helper/src/lib.rs">example helper library</a>.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2022 Chance Snow. All rights reserved.
/// License: MIT License
module examples.window;

import std.conv : to;
import std.typecons : Tuple;

import bindbc.glfw;
import wgpu.api;

/// Last observed GLFW error.
static string lastError = null;

package extern(C) void wgpu_glfw_error_callback(int error, const char* description) nothrow {
  import std.conv : ConvException;
  import std.exception : assertNotThrown, assumeWontThrow, ifThrown;
  import std.stdio : stderr, writefln;
  import std.string : fromStringz;

  if (description is null) stderr.writefln("GLFW Error %d", error).assumeWontThrow;
  else {
    stderr.writefln("GLFW Error %d: %s", error, description).assumeWontThrow;
    lastError = description.fromStringz.to!string.ifThrown!ConvException(null).assumeWontThrow;
  }
}

package alias FutureTask = void delegate();

///
alias Size = Tuple!(uint, "width", uint, "height");

///
abstract class Window {
  import std.functional : toDelegate;
  import std.math : floor;
  import std.string : toStringz;
  import std.typecons : Yes;

  private GLFWwindow* _window = null;
  private Instance _gpu;
  private string _title;
  private Size _size;
  private string _controls = "Press ESC to quit";
  // Defer render target resizing until _after_ the current queue has finished.
  // This protects against cases where the framebuffer was resized during command recording
  private FutureTask[] futureTasks;
  private bool paused = false;

  /// GPU instance used to render to this window.
  Instance gpu() { return _gpu; }
  /// GPU surface backed by this window.
  const Surface surface;
  ///
  SwapChain swapChain;

  ///
  this(string title, uint width = 640, uint height = 480, Instance gpu = null) {
    _gpu = gpu is null ? Instance.create() : gpu;
    _title = title;

    glfwSetErrorCallback(&wgpu_glfw_error_callback);
    assert(glfwInit(), "GLFW was not initialized");

    // https://www.glfw.org/docs/3.3/window_guide.html#window_hints
    glfwWindowHint(GLFW_VISIBLE, false);
    glfwWindowHint(GLFW_RESIZABLE, true);
    glfwWindowHint(GLFW_FOCUSED, true);
    glfwWindowHint(GLFW_FOCUS_ON_SHOW, true);
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API); // Graphics are handled by WebGPU

    _window = glfwCreateWindow(width, height, title.toStringz, null, null);
    assert(_window !is null, "Could not create window:\n\t" ~ lastError);
    glfwSetWindowSizeLimits(_window, width, height, GLFW_DONT_CARE, GLFW_DONT_CARE);
    _size = Size(width, height);

    // Create GPU surface backed by this window
    version (OSX) {
      import std.exception : enforce;

      auto nativeWindow = NSWindow.from(enforce(glfwGetCocoaWindow(_window), lastError));
      auto metalLayer = CAMetalLayer.classOf.layer;
      nativeWindow.contentView.wantsLayer = true;
      nativeWindow.contentView.layer = metalLayer;
      surface = Surface.fromMetalLayer(this.gpu, metalLayer.asId);
    }
    else version (Linux) surface = Surface.fromXlib(
      this.gpu, assert(glfwGetX11Display()), assert(glfwGetX11Window(_window))
    );
    // TODO: Integrate with Windows platform, i.e. Surface.fromWindowsHwnd
    else static assert(0, "Unsupported target platform");
    assert(surface.id !is null, "Could not create native surface");

    glfwSetWindowIconifyCallback(_window, ((GLFWwindow*, int iconified) nothrow {
      paused = iconified != 0;
    }).toDelegate.bindDelegate);
    glfwSetFramebufferSizeCallback(_window, ((GLFWwindow*, int width, int height) nothrow {
      import std.conv : ConvException;
      import std.exception : assumeWontThrow, ifThrown;

      _size.width = width.to!uint.ifThrown!ConvException(_size.width).assumeWontThrow;
      _size.height = height.to!uint.ifThrown!ConvException(_size.height).assumeWontThrow;
    }).toDelegate.bindDelegate);
  }
  ~this() {
    glfwTerminate();
  }

  /// Title of this window.
  string title() @property const {
    return _title;
  }

  /// Size of this window's framebuffer, in pixels.
  /// See_Also: GLFW's <a href="https://www.glfw.org/docs/3.3/window_guide.html#window_size">window size</a> documentation.
  Size size() @trusted {
    import std.typecons : tuple;
    assert(_window !is null);

    int w, h;
    glfwGetFramebufferSize(cast(GLFWwindow*) _window, &w, &h);
    assert((w != 0 && h != 0) || paused, lastError);
    if (paused) return _size;

    _size.width = w.to!uint;
    _size.height = h.to!uint;
    return _size;
  }

  /// Creates a swap chain given this window's GPU surface and size.
  SwapChain createSwapChain(const Device device, TextureFormat format) {
    // The render pipeline renders data into this swap chain
    return swapChain = device.createSwapChain(
      surface, _size.width, _size.height, format,
      // TODO: Remove this redundant texture usage parameter
      TextureUsage.renderAttachment,
      PresentMode.fifo,
      title
    );
  }

  ///
  abstract void initialize(const Device device);
  ///
  abstract void resizeRenderTarget(const Device device);
  ///
  abstract void render(const Device device);

  ///
  void runEventLoop(const Device device) {
    initialize(device);

    glfwSetFramebufferSizeCallback(_window, bindDelegate((GLFWwindow*, int, int) nothrow {
      futureTasks ~= () => resizeRenderTarget(device);
    }.toDelegate));

    double elapsedTime = 0;
    const uint desiredFps = 60;
    /// Approximate measure of the current FPS.
    double currentFps = 0;

    glfwShowWindow(_window);
    while (!glfwWindowShouldClose(_window)) {
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
      glfwSetWindowTitle(_window, format!"%s - %s - %s"(title, _controls, frameStatistics).toStringz);

      // Update
      if (glfwGetKey(_window, GLFW_KEY_ESC) == GLFW_PRESS) break;
      if (futureTasks.length) {
        foreach (task; futureTasks) task();
        futureTasks = [];
      }

      // Render
      this.render(device);
    }
  }
}

package:

import std.traits : isDelegate, isImplicitlyConvertible;

/// Convert `value`, in seconds, to milliseconds.
/// Returns: `value` converted to milliseconds, rounded down to to the nearest positive integer.
/// If the conversion overflows, zero is returned.
ulong ms(T)(T value) nothrow if (isImplicitlyConvertible!(T, real)) {
  import std.conv : ConvOverflowException;
  import std.exception : assumeWontThrow, ifThrown;
  import std.math : floor;

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
