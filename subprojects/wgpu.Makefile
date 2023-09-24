# See https://github.com/gfx-rs/wgpu-native/tree/v0.10.4.1
VERSION := v0.10.4.1
OS := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Darwin)
	RELEASE := macos
	LIB_WGPU_EXT := dylib
endif
ifeq ($(OS),Linux)
	RELEASE := linux
	LIB_WGPU_EXT := so
endif
# TODO: Add Windows support
ifndef RELEASE
	$(error Unsupported WebGPU target OS: $(OS))
endif

CONFIG ?= debug

BINARY_ARCHIVE := https://github.com/gfx-rs/wgpu-native/releases/download/$(VERSION)/wgpu-$(RELEASE)-$(ARCH)-$(CONFIG).zip
$(info Using $(CONFIG) wgpu-native@$(VERSION) from: $(BINARY_ARCHIVE))

.DEFAULT_GOAL := wgpu/wgpu.h
wgpu/libwgpu.$(LIB_WGPU_EXT):
wgpu/wgpu.h:
	@echo "Downloading WebGPU Native binaries…"
	@curl -L $(BINARY_ARCHIVE) --output /tmp/wgpu.zip
	@echo "Unzipping WebGPU Native binaries…"
	@unzip -q /tmp/wgpu.zip -d wgpu
