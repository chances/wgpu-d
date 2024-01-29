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
LIB_WGPU_SOURCE := subprojects/wgpu
$(LIB_WGPU_SOURCE): subprojects/wgpu.Makefile
	@make -C subprojects -f wgpu.Makefile
$(LIB_WGPU_SOURCE)/$(LIB_WGPU): $(LIB_WGPU_SOURCE)
wgpu: $(LIB_WGPU_SOURCE)/$(LIB_WGPU)
.PHONY: wgpu

#################################################
# Test Coverage
#################################################
cover: $(SOURCES)
	dub test --build=unittest-cov

#################################################
# Documentation
#################################################

PACKAGE_VERSION := 0.3.0
docs/sitemap.xml: $(SOURCES)
	dub build -b ddox
	@echo "Performing cosmetic changes..."
	# Navigation Sidebar
	@$(SED) -i -e "/<nav id=\"main-nav\">/r views/nav.html" -e "/<nav id=\"main-nav\">/d" `find docs -name '*.html'`
	# Page Titles
	@$(SED) -i "s/<\/title>/ - wgpu-d<\/title>/" `find docs -name '*.html'`
	# Index
	@$(SED) -i "s/API documentation/API Reference/g" docs/index.html
	@$(SED) -i -e "/<h1>API Reference<\/h1>/r views/index.html" -e "/<h1>API Reference<\/h1>/d" docs/index.html
	# License Link
	@$(SED) -i "s/3-Clause BSD License/<a href=\"https:\/\/opensource.org\/licenses\/BSD-3-Clause\">3-Clause BSD License<\/a>/" `find docs -name '*.html'`
	# Footer
	@$(SED) -i -e "/<p class=\"faint\">Generated using the DDOX documentation generator<\/p>/r views/footer.html" -e "/<p class=\"faint\">Generated using the DDOX documentation generator<\/p>/d" `find docs -name '*.html'`
	# Dub Package Version
	@echo `git describe --tags --abbrev=0`
	@$(SED) -i "s/DUB_VERSION/$(PACKAGE_VERSION)/g" `find docs -name '*.html'`
	@echo Done

docs: docs/sitemap.xml
ifeq ($(OS),Windows_NT)
	$(error Build documentation on *nix!)
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
