OS := $(shell uname -s)
ifeq ($(OS),Darwin)
CC := clang
SED := gsed
endif
ifeq ($(OS),Linux)
CC := gcc
endif
ifndef CC
$(error Unsupported target OS '$(OS)')
endif
ifndef SED
SED := sed
endif
SOURCES := $(shell find source -name '*.d')
LIBS_PATH := lib

.DEFAULT_GOAL := docs
all: docs

#################################################
# Subprojects
#################################################
ifeq ($(OS),Darwin)
LIB_WGPU_EXT := dylib
endif
ifeq ($(OS),Linux)
LIB_WGPU_EXT := so
endif
ifndef LIB_WGPU_EXT
$(error Unsupported target OS '$(OS)')
endif
LIB_WGPU_SOURCE := subprojects/wgpu/libwgpu.$(LIB_WGPU_EXT)
LIB_WGPU := lib/libwgpu.$(LIB_WGPU_EXT)
wgpu: $(LIB_WGPU)
.PHONY: wgpu
subprojects/wgpu/wgpu.h: subprojects/wgpu.Makefile
	@make -C subprojects -f wgpu.Makefile
$(LIB_WGPU): $(LIB_WGPU_SOURCE)
	@mkdir -p lib
	@cp $(LIB_WGPU_SOURCE) lib/.

#################################################
# Examples
#################################################
example_utils_SOURCES := $(shell find examples/utils/source -name '*.d')
EXAMPLES := bin/cube bin/headless bin/triangle
examples: $(EXAMPLES)
.PHONY: examples

cube_SOURCES := $(example_utils_SOURCES) $(shell find examples/cube/source -name '*.d')
bin/cube: $(SOURCES) $(cube_SOURCES) examples/cube/dub.json
	cd examples/cube && dub build

headless_SOURCES := $(shell find examples/headless/source -name '*.d')
bin/headless: $(SOURCES) $(headless_SOURCES) examples/headless/dub.json
	cd examples/headless && dub build

triangle_SOURCES := $(shell find examples/triangle/source -name '*.d')
bin/triangle: $(SOURCES) $(triangle_SOURCES) examples/triangle/dub.json
	cd examples/triangle && dub build

cover: $(SOURCES)
	dub test --build=unittest-cov

#################################################
# Documentation
#################################################

PACKAGE_VERSION := 0.1.2
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
.PHONY: docs

clean: clean-docs
	rm -rf bin lib
	dub clean
	@echo "Cleaning code coverage reports..."
	rm -f -- *.lst
.PHONY: clean

clean-docs:
	@echo "Cleaning generated documentation..."
	@rm -f docs.json
	@rm -f docs/sitemap.xml docs/file_hashes.json
	@rm -rf `find docs -name '*.html'`
.PHONY: clean-docs
