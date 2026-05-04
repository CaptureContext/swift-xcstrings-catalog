@testable import XCStringsCatalogParser

struct TestXCStringParser: XCStringParser {
	let underlying = DefaultXCStringParser()

	func parse(
		_ input: String,
		expandingSubstitutions substitutions: [String : String]
	) -> [ParsedXCStringSegment] {
		underlying.parse(input, expandingSubstitutions: substitutions)
	}
}
