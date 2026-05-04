// swift-tools-version: 6.1

import Foundation
import PackageDescription

let package = Package(
	name: "swift-xcstrings-catalog",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13),
		.visionOS(.v1),
	],
	products: [
		.library(
			name: "_XCStringResource",
			targets: ["_XCStringResource"]
		),
		.library(
			name: "_XCStringsSource",
			targets: ["_XCStringsSource"]
		),
		.library(
			name: "XCStringsCatalog",
			targets: ["XCStringsCatalog"]
		),
		.library(
			name: "XCStringsCatalogCore",
			targets: ["XCStringsCatalogCore"]
		),
		.library(
			name: "XCStringsCatalogParser",
			targets: ["XCStringsCatalogParser"]
		),
		.library(
			name: "XCStringsCatalogValidator",
			targets: ["XCStringsCatalogValidator"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
			.upToNextMajor(from: "1.19.2")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-dependencies.git",
			.upToNextMajor(from: "1.12.0")
		),
	],
	targets: [
		.target(
			name: "_XCStringResource",
			dependencies: []
		),
		.target(
			name: "_XCStringsSource",
			dependencies: [
				.target(name: "XCStringsCatalogCore")
			]
		),
		.target(
			name: "XCStringsCatalog",
			dependencies: [
				.target(name: "XCStringsCatalogCore"),
				.target(
					name: "XCStringsCatalogParser",
					condition: .when(traits: ["Parsing"])
				),
			]
		),
		.target(
			name: "XCStringsCatalogCore",
			dependencies: []
		),
		.target(
			name: "XCStringsCatalogParser",
			dependencies: [
				.target(name: "XCStringsCatalogCore"),
				.target(name: "_XCStringsSource"),
				.target(name: "_XCStringResource"),
				.product(
					name: "Dependencies",
					package: "swift-dependencies"
				),
			]
		),
		.target(
			name: "XCStringsCatalogValidator",
			dependencies: [
				.target(name: "_XCStringResource"),
				.product(
					name: "Dependencies",
					package: "swift-dependencies"
				),
			]
		),
		.testTarget(
			name: "XCStringsCatalogParserTests",
			dependencies: [
				.target(name: "XCStringsCatalogParser"),
				.product(
					name: "SnapshotTestingCustomDump",
					package: "swift-snapshot-testing"
				),
			],
			resources: [
				.copy("__Fixtures__")
			]
		)
	],
	swiftLanguageModes: [.v6]
)


#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

// Workaround to ensure that all traits are included in documentation. Swift Package Index adds
// SPI_GENERATE_DOCS (https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues/2336)
// when building documentation, so only tweak the default traits in this condition.
let spiGenerateDocs = ProcessInfo.processInfo.environment["SPI_GENERATE_DOCS"] != nil

// Enable all traits for other CI actions.
let enableAllTraitsExplicit = ProcessInfo.processInfo.environment["ENABLE_ALL_TRAITS"] != nil

let enableAllTraits = spiGenerateDocs || enableAllTraitsExplicit

package.traits.formUnion([
	.trait(
		name: "Parsing",
		description: "Enables parser export for main product"
	),
])

package.traits.insert(.default(
	enabledTraits: Set(enableAllTraits ? package.traits.map(\.name) : [])
))
