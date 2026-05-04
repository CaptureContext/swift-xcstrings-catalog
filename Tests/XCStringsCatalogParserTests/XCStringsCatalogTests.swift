import Testing
import XCStringsCatalogCore

import Foundation
import SnapshotTesting

@Suite
struct XCStringsCatalogTests {
	@Test
	func createCatalog() async throws {
		let stringUnit = XCStringUnit(state: .translated, value: "Example value")
		let variations = XCStringVariations(device: [.iPad: XCStringVariation(stringUnit: stringUnit)], plural: [:])
		let substitutions = ["substitution": XCStringSubstitution(argNum: 0, formatSpecifier: "%lld", variations: variations)]
		let localization = XCStringLocalization(stringUnit: stringUnit, substitutions: substitutions, variations: variations)
		let entry = XCStringEntry(comment: "A comment", extractionState: "manual", localizations: [ "en": localization ])
		let catalog = XCStringsCatalog(sourceLanguage: "en", strings: ["ExampleKey": entry], version: "1.0")
		assertSnapshot(of: catalog, as: .json)
	}

	@Test
	func parsePrintCatalog() async throws {
		let fixtureURL = try fixtureURL(for: "Localizable")
		let catalog = try XCStringsCatalog(contentsOf: fixtureURL)
		assertSnapshot(of: catalog, as: .json)
	}
}
