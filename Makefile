SOURCES := $(shell find source -name '*.d')
TARGET_OS := $(shell uname -s)
LIBS_PATH := lib/wgpu-64-debug

.DEFAULT_GOAL := docs
all: docs

EXAMPLES := bin/headless
examples: $(EXAMPLES)

.PHONY: examples

HEADLESS_SOURCES := $(shell find examples/headless/source -name '*.d')
ifeq ($(TARGET_OS),Linux)
	HEADLESS_SOURCES := $(HEADLESS_SOURCES)
endif

bin/headless: $(SOURCES) $(HEADLESS_SOURCES) library-sanity-check
	cd examples/headless && dub build

headless: bin/headless
	env LD_LIBRARY_PATH=$(LIBS_PATH) bin/headless
.PHONY: headless

library-sanity-check:
	@echo "Sanity check for Linking to wgpu-native:"
	ld -L$(LIBS_PATH) -l wgpu_native
	@rm -f a.out
	@echo "All good! 👍️"
.PHONY: library-sanity-check

test: library-sanity-check
	env LD_LIBRARY_PATH=$(LIBS_PATH) dub test --parallel
.PHONY: test

cover: $(SOURCES) library-sanity-check
	env LD_LIBRARY_PATH=$(LIBS_PATH) dub test --parallel --coverage

PACKAGE_VERSION := 0.1.0-alpha.1
docs/sitemap.xml: $(SOURCES)
	dub build -b ddox
	@echo "Performing cosmetic changes..."
	# Navigation Sidebar
	@sed -i -e "/<nav id=\"main-nav\">/r views/nav.html" -e "/<nav id=\"main-nav\">/d" `find docs -name '*.html'`
	# Page Titles
	@sed -i "s/<\/title>/ - wgpu-d<\/title>/" `find docs -name '*.html'`
	# Index
	@sed -i "s/API documentation/API Reference/g" docs/index.html
	@sed -i -e "/<h1>API Reference<\/h1>/r views/index.html" -e "/<h1>API Reference<\/h1>/d" docs/index.html
	# License Link
	@sed -i "s/3-Clause BSD License/<a href=\"https:\/\/opensource.org\/licenses\/BSD-3-Clause\">3-Clause BSD License<\/a>/" `find docs -name '*.html'`
	# Footer
	@sed -i -e "/<p class=\"faint\">Generated using the DDOX documentation generator<\/p>/r views/footer.html" -e "/<p class=\"faint\">Generated using the DDOX documentation generator<\/p>/d" `find docs -name '*.html'`
	# Dub Package Version
	@echo `git describe --tags --abbrev=0`
	@sed -i "s/DUB_VERSION/$(PACKAGE_VERSION)/g" `find docs -name '*.html'`
	@echo Done

docs: docs/sitemap.xml
.PHONY: docs

clean:
	rm -f bin/headless
	rm -f $(EXAMPLES)
	rm -f docs.json
	rm -f docs/sitemap.xml docs/file_hashes.json
	rm -rf `find docs -name '*.html'`
	rm -f -- *.lst
.PHONY: clean
