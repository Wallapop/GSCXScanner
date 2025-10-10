# Xcode Project Generation

This directory contains the configuration for generating an Xcode project from Bazel using `rules_xcodeproj`.

## Prerequisites

- Bazel 7.0 or later
- Xcode 15.0 or later

## Generating the Xcode Project

To generate the Xcode project, run:

```bash
bazel run //xcodeproj:GSCXScanner
```

This will create a `GSCXScanner.xcodeproj` in the root directory.

## Opening the Project

After generation, you can open the project with:

```bash
open GSCXScanner.xcodeproj
```

Or simply double-click the `.xcodeproj` file in Finder.

## What You Can Do in Xcode

Once the project is open, you can:

- **Browse and edit source files** - All `.h`, `.m`, and `.swift` files
- **Preview and edit XIB files** - Interface Builder integration works out of the box
- **Navigate code** - Full indexing and code completion
- **Build the library** - The project is configured to build using Bazel
- **Debug** - Set breakpoints and debug your code

## Build Modes

The project supports two build modes:

1. **Bazel Build Mode** (default) - Builds are performed by Bazel for accuracy
2. **Xcode Build Mode** - Faster incremental builds, but less accurate

The default is Bazel mode to ensure builds match what Bazel produces.

## Targets

The generated project includes:

- `gscx_scanner_objc` - Objective-C library code
- `gscx_scanner_swift` - Swift UI components

## Regenerating the Project

If you make changes to BUILD files or add new source files, regenerate the project:

```bash
bazel run //xcodeproj:GSCXScanner
```

## Troubleshooting

### Project won't generate

Make sure all Bazel dependencies are available:

```bash
bazel sync --configure
```

### XIB files won't open

Make sure the XIB files are included in the `data` attribute of the `objc_library` target in `BUILD.bazel`.

### Code completion not working

Try regenerating the project and rebuilding:

```bash
bazel run //xcodeproj:GSCXScanner
open GSCXScanner.xcodeproj
# In Xcode: Product > Build
```
