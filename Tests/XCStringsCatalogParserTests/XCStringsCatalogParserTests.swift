import Testing
import XCStringsCatalogCore
@testable import XCStringsCatalogParser

import Dependencies
import SnapshotTesting
import SnapshotTestingCustomDump

@Suite
struct DefaultXCStringsCatalogParserTests {
	@Test
	func parse() async throws {
		withDependencies {
			$0.xcStringParser = TestXCStringParser()
		} operation: {

		}
		let sut = DefaultXCStringsCatalogParser()
		let fixtureURL = try fixtureURL(for: "Localizable")
		let catalog = try XCStringsCatalog(contentsOf: fixtureURL)
		let result = try sut.parse(from: .catalog(catalog))
		assertSnapshots(
			of: result.resources,
			as: ["resouces.dump": .customDump]
		)
		assertSnapshots(
			of: result.issues.sorted(by: { $0.key < $1.key || $0.description < $1.description }),
			as: ["issues.dump": .customDump]
		)
	}
}
