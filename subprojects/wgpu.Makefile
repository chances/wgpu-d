# See https://github.com/gfx-rs/wgpu-native/tree/v0.19.1.1
VERSION := v0.19.1.1
OS ?= $(shell uname -s)
ifeq ($(findstring cmd.exe,$(SHELL)),cmd.exe)
  UNIX := false
endif
ifeq ($(findstring sh.exe,$(SHELL)),sh.exe)
  UNIX := true
endif
# Else, assume a unix system
UNIX ?= true

# Detect current system's CPU architecture
ifeq ($(OS),Windows_NT)
  ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
    ARCH := x86_64
  else
    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
      ARCH := x86_64
    endif
    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
    	ARCH := i686
    endif
  endif
  ifndef ARCH
    $(error Unsupported target CPU architecture: $(OS))
  endif
endif
ARCH ?= $(shell uname -m)

# wgpu-native binaries ships with static libraries 🎉
ifeq ($(OS),Darwin)
  RELEASE := macos
  LIB_WGPU := libwgpu_native.a
endif
ifeq ($(OS),Linux)
  RELEASE := linux
  LIB_WGPU := libwgpu_native.a
endif
ifeq ($(OS),Windows_NT)
  RELEASE := windows
  LIB_WGPU := wgpu_native.lib
endif
ifndef RELEASE
  $(error Unsupported WebGPU target OS: $(OS))
endif

CONFIG ?= debug

.DEFAULT_GOAL := wgpu/$(LIB_WGPU)

BINARY_ARCHIVE := https://github.com/gfx-rs/wgpu-native/releases/download/$(VERSION)/wgpu-$(RELEASE)-$(ARCH)-$(CONFIG).zip
$(info Using $(CONFIG) wgpu-native $(VERSION) from: $(BINARY_ARCHIVE))
ifeq ($(OS),Windows_NT)
ifeq ($(UNIX),true)
  ARCHIVE_DIR := $(shell echo $(USERPROFILE)/AppData/Local/WebGPU)
  ARCHIVE_ZIP := $(shell echo $(USERPROFILE)/AppData/Local/WebGPU/wgpu.zip)
else
  ARCHIVE_DIR := $(shell echo %USERPROFILE%/AppData/Local/WebGPU)
  ARCHIVE_ZIP := $(shell echo %USERPROFILE%/AppData/Local/WebGPU/wgpu.zip)
endif
else
  ARCHIVE_ZIP := /tmp/wgpu.zip
endif
$(ARCHIVE_ZIP):
	@echo Downloading WebGPU Native binaries...
ifeq ($(OS),Windows_NT)
	@echo Creating binary cache: $(ARCHIVE_DIR)
ifeq ($(UNIX),true)
	@mkdir -p $(ARCHIVE_DIR)
else
	@if not exist $(ARCHIVE_DIR) mkdir $(ARCHIVE_DIR)
endif
endif
	@curl -L $(BINARY_ARCHIVE) --output $(ARCHIVE_ZIP)

wgpu/$(LIB_WGPU): $(ARCHIVE_ZIP)
	@echo Unzipping WebGPU Native binaries...
ifeq ($(UNIX),true)
	@mkdir -p wgpu
	@unzip -q -o $(ARCHIVE_ZIP) -d wgpu
else
	@if not exist wgpu mkdir wgpu
	@tar -xf $(ARCHIVE_ZIP) -C wgpu
endif
