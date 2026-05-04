# swift-xcstrings-catalog

[![CI](https://github.com/capturecontext/swift-xcstrings-catalog/actions/workflows/ci.yml/badge.svg)](https://github.com/capturecontext/swift-xcstrings-catalog/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswift-xcstrings-catalog%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capturecontext/swift-xcstrings-catalog) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswift-xcstrings-catalog%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/capturecontext/swift-xcstrings-catalog)

Library for parsing and generating `xcstrings` files

## Table of Contents

- [Motivation](motivation)
- [Installation](installation)
- [License](license)

## Motivation

This fork of [`liamnichols/swift-localized-strings`](https://github.com/liamnichols/swift-localized-strings) brings the following adjustments:

- Adjusted naming conventions
- Adjusted placeholders detection
- Introduces package traits (`Swift 6.1`)
- Uses [`pointfreeco/swift-dependencies`](https://github.com/pointfreeco/swift-dependencies)
- Uses [`pointfreeco/swift-snapshot-testing`](https://github.com/pointfreeco/swift-snapshot-testing)
- Uses tabs for indentation

To match our vision for [`capturecontext/package-resources-cli`](capturecontext/package-resources-cli) localized strings support

## Installation

### Basic

You can add `swift-xcstrings-catalog` to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-xcstrings-catalog"`](https://github.com/capturecontext/swift-xcstrings-catalog) into the package repository URL text field
3. Choose products you need to link to your project.

### Recommended

If you use SwiftPM for your project structure, add `swift-xcstrings-catalog` dependency to your package file

```swift
.package(
  url: "https://github.com/capturecontext/swift-xcstrings-catalog.git", 
  .upToNextMinor(from: "1.0.0")
)
```

Do not forget about target dependencies

```swift
.product(
  name: "XCStringsCatalog", 
  package: "swift-xcstrings-catalog"
)
```
