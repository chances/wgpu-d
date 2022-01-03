VERSION := v0.10.4.1
OS := $(shell uname -s)
ARCH := $(shell uname -m)

ifeq ($(OS),Darwin)
	RELEASE := macos
endif
ifeq ($(OS),Linux)
	RELEASE := linux
endif
ifndef RELEASE
	$(error Unsupported WebGPU target OS: $(OS))
endif

ifndef CONFIG
	CONFIG := debug
endif

BINARY_ARCHIVE := https://github.com/gfx-rs/wgpu-native/releases/download/$(VERSION)/wgpu-$(RELEASE)-$(ARCH)-$(CONFIG).zip

.DEFAULT_GOAL := wgpu/wgpu.h
wgpu/wgpu.h:
	@echo "Downloading WebGPU Native binaries…"
	@curl -L $(BINARY_ARCHIVE) --output /tmp/wgpu.zip
	@echo "Unzipping WebGPU Native binaries…"
	@unzip -q /tmp/wgpu.zip -d wgpu
