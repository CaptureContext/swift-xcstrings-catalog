import Foundation
import _XCStringResource

extension DefaultXCStringsCatalogParser {
	@usableFromInline
	func collect(
		collector: (
			inout [XCStringResource],
			inout [ExtractionIssue]
		) throws -> Void
	) rethrows -> Output {
		var resources: [XCStringResource] = []
		var issues: [ExtractionIssue] = []

		try collector(&resources, &issues)
		
		return .init(
			resources: resources.sorted(),
			issues: issues
		)
	}
}
