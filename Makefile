OS ?= $(shell uname -s)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
ifeq ($(OS),Darwin)
  CC := clang
  SED := gsed
else ifeq ($(OS),Linux)
  CC := gcc
else ifeq ($(OS),Windows_NT)
  CC := cl
endif
ifndef CC
  $(error Unsupported target OS '$(OS)')
endif
ifndef SED
  SED := sed
endif
SOURCES := $(call rwildcard,source/,*.d)
LIBS_PATH := lib

.DEFAULT_GOAL := docs
all: docs

#################################################
# Subprojects
#################################################
# wgpu-native binaries ships with static libraries 🎉
ifeq ($(OS),Darwin)
  LIB_WGPU := libwgpu_native.a
else ifeq ($(OS),Linux)
  LIB_WGPU := libwgpu_native.a
else ifeq ($(OS),Windows_NT)
  LIB_WGPU := wgpu_native.lib
endif
ifndef LIB_WGPU
  $(error Unsupported target OS '$(OS)')
endif
subprojects/wgpu: subprojects/wgpu.Makefile
	@make --no-print-directory -C subprojects -f wgpu.Makefile
ifneq ($(OS),Windows_NT)
	file subprojects/wgpu/$(LIB_WGPU)
else
	IF EXIST subprojects/wgpu/$(LIB_WGPU) ECHO subprojects/wgpu/$(LIB_WGPU) exists.
endif
subprojects/wgpu/$(LIB_WGPU): subprojects/wgpu
wgpu: subprojects/wgpu/$(LIB_WGPU)
.PHONY: wgpu

#################################################
# Test Coverage
#################################################
cover: $(SOURCES)
	dub test --build=unittest-cov
.PHONY: cover

#################################################
# Documentation
#################################################

docs: docs/sitemap.xml
ifeq ($(OS),Windows_NT)
	$(error Build documentation on *nix!)
else
	@dub build -b docs
endif
.PHONY: docs

clean:
ifneq ($(OS),Windows_NT)
clean: clean-docs
else
	$(error Build documentation on *nix!)
endif
	dub clean
	@rm -rf bin lib
	@echo "Cleaning code coverage reports..."
	@rm -f -- *.lst
.PHONY: clean

DOCS_HTML := $(call rwildcard,docs/,*.html)
clean-docs:
ifeq ($(OS),Windows_NT)
	$(error Build documentation on *nix!)
endif
	@echo "Cleaning generated documentation..."
	@rm -f docs.json
	@rm -f docs/sitemap.xml docs/file_hashes.json
	@rm -rf $(DOCS_HTML)
.PHONY: clean-docs
