.PHONY: setup build check clean dev

# One-time setup: install the wasm target
setup:
	rustup target add wasm32-wasip1

# Build release wasm binary
build:
	cargo build --target wasm32-wasip1 --release

# Quick compilation check
check:
	cargo check --target wasm32-wasip1

# Remove build artifacts
clean:
	cargo clean

# Build and install as dev extension in Zed
dev: build
	@echo ""
	@echo "Build complete. To install in Zed:"
	@echo "  1. Open Zed"
	@echo "  2. Cmd+Shift+P → 'zed: install dev extension'"
	@echo "  3. Select this directory: $(CURDIR)"
