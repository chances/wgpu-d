VERSION := 3.3.6

ifeq ($(OS),Windows_NT)

.DEFAULT_GOAL := glfw/src/glfw3.lib

ARCHIVE_ZIP := $(shell echo %USERPROFILE%/AppData/Local/Temp/glfw-$(VERSION).zip)
# See https://stackoverflow.com/a/7487697/1363247
glfw:
	@echo Downloading GLFW sources...
	@curl -L https://github.com/glfw/glfw/releases/download/$(VERSION)/glfw-$(VERSION).zip --output $(ARCHIVE_ZIP)
	@echo Unzipping GLFW sources...
	@tar -xf $(ARCHIVE_ZIP) -C .
	robocopy glfw-3.3.6 glfw /move /e /NFL /NDL /NJH /nc /ns /np
	@rmdir glfw-3.3.6 /s /q
glfw/src/glfw3.lib: glfw
	@echo Building GLFW...
	cmake -B glfw glfw -DCMAKE_BUILD_TYPE=Release -DUSE_MSVC_RUNTIME_LIBRARY_DLL=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF -G"Unix Makefiles"
	make -C glfw

else

.DEFAULT_GOAL := glfw/src/libglfw3.a

glfw:
	@echo "Downloading GLFW sources…"
	@curl -L https://github.com/glfw/glfw/releases/download/$(VERSION)/glfw-$(VERSION).zip --output /tmp/glfw-$(VERSION).zip
	@echo "Unzipping GLFW sources…"
	@unzip -f -q /tmp/glfw-$(VERSION).zip
	@mv --force glfw-3.3.6 glfw
glfw/src/libglfw3.a: glfw
	@echo "Building GLFW…"
	cmake -B glfw glfw -DCMAKE_BUILD_TYPE=Release -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF -G"Unix Makefiles"
	make -C glfw

clean:
	rm -rf glfw
.PHONY: clean

endif
