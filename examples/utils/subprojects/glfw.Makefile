VERSION := 3.3.6
OS ?= $(shell uname -s)

ifeq ($(OS),Windows_NT)
  TARGET := glfw/src/glfw3.lib
else
  TARGET := glfw/src/libglfw3.a
endif

.DEFAULT_GOAL := $(TARGET)

ifeq ($(OS),Windows_NT)
  ARCHIVE_ZIP := $(shell echo %USERPROFILE%/AppData/Local/Temp/glfw-$(VERSION).zip)
else
  ARCHIVE_ZIP := /tmp/glfw-$(VERSION).zip
endif

DEFINES := GLFW_BUILD_TESTS=OFF GLFW_BUILD_EXAMPLES=OFF GLFW_BUILD_DOCS=OFF
ifeq ($(OS),Windows_NT)
  DEFINES += USE_MSVC_RUNTIME_LIBRARY_DLL=ON
endif

$(TARGET):
	@echo Downloading GLFW sources...
ifeq ($(OS),Windows_NT)
	@if exist $(ARCHIVE_ZIP) echo Using cached download.
	@if not exist $(ARCHIVE_ZIP) curl -L https://github.com/glfw/glfw/releases/download/$(VERSION)/glfw-$(VERSION).zip --output $(ARCHIVE_ZIP)
else
	@curl -L https://github.com/glfw/glfw/releases/download/$(VERSION)/glfw-$(VERSION).zip --output $(ARCHIVE_ZIP)
endif
	@echo Unzipping GLFW sources...
ifeq ($(OS),Windows_NT)
	@if not exist glfw tar -xf $(ARCHIVE_ZIP)
	@if not exist glfw rdmd --eval "std.file.rename(\"glfw-$(VERSION)\", \"glfw\");"
else
	@unzip -q /tmp/glfw-$(VERSION).zip
	@mv glfw-$(VERSION) glfw
endif
	@echo Building GLFW...
	cmake -B glfw glfw -G "Unix Makefiles" $(patsubst %, -D%, $(DEFINES))
	make -C glfw
