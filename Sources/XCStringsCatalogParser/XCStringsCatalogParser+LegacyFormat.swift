import _XCStringResource
import _XCStringsSource

extension DefaultXCStringsCatalogParser {
	@usableFromInline
	func extractResources(
		from legacyFormat: XCStringsSource.LegacyFormat
	) throws -> Output {
		try collect { resources, _ in
			for (key, value) in legacyFormat {
				try resources.append(XCStringResource(key: key, value: value))
			}
		}
	}
}
