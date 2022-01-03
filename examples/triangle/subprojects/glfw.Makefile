VERSION := 3.3.6

.DEFAULT_GOAL := glfw/src/libglfw3.a

glfw/src/libglfw3.a:
	@echo "Downloading GLFW sources…"
	@curl -L https://github.com/glfw/glfw/releases/download/$(VERSION)/glfw-$(VERSION).zip --output /tmp/glfw-$(VERSION).zip
	@echo "Unzipping GLFW sources…"
	@unzip -q /tmp/glfw-$(VERSION).zip
	@mv glfw-3.3.6 glfw
	@echo "Building GLFW…"
	@cd glfw && \
	cmake . -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF && \
	make
