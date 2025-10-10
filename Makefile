.PHONY: help xcode clean build test

help:
	@echo "GSCXScanner Bazel Commands"
	@echo ""
	@echo "  make xcode     - Generate Xcode project"
	@echo "  make open      - Generate and open Xcode project"
	@echo "  make build     - Build the library"
	@echo "  make clean     - Clean build artifacts"
	@echo "  make sync      - Sync Bazel dependencies"
	@echo ""

xcode:
	@echo "Generating Xcode project..."
	bazel run //xcodeproj:GSCXScanner

open: xcode
	@echo "Opening Xcode project..."
	open GSCXScanner.xcodeproj

build:
	@echo "Building GSCXScanner..."
	bazel build //:GSCXScanner

framework:
	@echo "Building GSCXScanner framework..."
	bazel build //:GSCXScanner_framework

xcframework:
	@echo "Building GSCXScanner XCFramework..."
	bazel build //:GSCXScanner_xcframework

clean:
	@echo "Cleaning build artifacts..."
	bazel clean

sync:
	@echo "Syncing Bazel dependencies..."
	bazel sync --configure
