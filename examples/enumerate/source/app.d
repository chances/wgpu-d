import std.conv : text, to;
import std.stdio;
import std.string : fromStringz;

import wgpu.api;

// Adapted from https://github.com/gfx-rs/wgpu-rs/blob/f6123e4fe89f74754093c07b476099623b76dd08/examples/capture/main.rs
void main() {
  writeln("Enumerating Device Adapters Example\n");

  auto instance = Instance.create();
  assert(instance.id, "Could not create WebGPU instance.");
  auto preferredBackend = cast(BackendType) instance.report.backendType;

  writefln("Preferred backend type: %s", preferredBackend);
  auto adapters = instance.adapters;
  writefln("Found %d suitable adapter(s):", adapters.length);
  for (int i = 0; i < adapters.length; i++) {
    auto adapter = adapters[i];
    auto props = adapter.properties;
    writefln("Adapter %d", i);
    writefln("\tvendorID: %u", props.vendorID);
    writefln("\tvendorName: %s", props.vendorName.fromStringz.to!string);
    writefln("\tarchitecture: %s", props.architecture.fromStringz.to!string);
    writefln("\tdeviceID: %u", props.deviceID);
    writefln("\tname: %s", props.name.fromStringz.to!string);
    writefln("\tdriverDescription: %s", props.driverDescription.fromStringz.to!string);
    writefln("\tadapterType: %s", cast(AdapterType) props.adapterType);
    writefln("\tbackendType: %s", cast(BackendType) props.backendType);
    write('\n');
    if (adapter.ready) adapter.destroy();
  }

  if (adapters.length == 0) assert(0, "WebGPU is not supported on this device. Try updating your graphics drivers.");

  auto adapter = instance.requestAdapter(PowerPreference.lowPower, preferredBackend);
  assert(adapter.ready, "Adapter instance was not initialized: Adapter status: " ~ adapter.status.text);
  writefln("Adapter limits:\n%s", adapter.limits.toString);
  writeln();

  auto device = adapter.requestDevice(adapter.limits);
  assert(device.ready, "Device is not ready: Device status: " ~ device.status.text);
  writefln("Device limits:\n%s", device.limits.toString);
  writeln();

  device.destroy();
  adapter.destroy();
  instance.destroy();
}
