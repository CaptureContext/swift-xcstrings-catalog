import XCStringsCatalogCore
import _XCStringResource

extension DefaultXCStringsCatalogParser {
	@usableFromInline
	func extractResources(
		from catalog: XCStringsCatalog
	) throws -> Output {
		try collect { resources, issues in
			for (key, value) in catalog.strings {
				// Retrieve the source localization for the given key. If it's missing, we skip it
				guard let localization = value.localizations?[catalog.sourceLanguage] else {
					issues.append(ExtractionIssue(
						key: key,
						reason: .missingSourceLocalization(catalog.sourceLanguage)
					))
					continue
				}

				// Only process manual strings
				guard value.extractionState == .manual else {
					issues.append(ExtractionIssue(
						key: key,
						reason: .wrongExtractionState(value.extractionState)
					))
					continue
				}

				// Attempt to process the resource from the catalog data
				try resources.append(
					XCStringResource(
						key: key,
						comment: value.comment,
						sourceLocalization: localization
					)
				)
			}
		}
	}
}
