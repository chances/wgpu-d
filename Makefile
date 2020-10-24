CWD := $(shell pwd)
SOURCES := source/wgpu.dpp

.DEFAULT_GOAL := all
all: source/wgpu.d

source/wgpu.d: $(SOURCES)
	@dub fetch dpp --cache=local
	dub run dpp --cache=local -- --preprocess-only --include-path "$(PWD)/source" $(SOURCES)
