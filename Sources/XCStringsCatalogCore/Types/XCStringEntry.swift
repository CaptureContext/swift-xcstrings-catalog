import Foundation

public struct XCStringEntry: Codable, Hashable, Sendable {
	public typealias Localizations = [XCStringLanguage: XCStringLocalization]

	public var comment: String?
	public var extractionState: XCStringExtractionState?
	public var localizations: Localizations?

	public init(
		comment: String? = nil,
		extractionState: XCStringExtractionState? = nil,
		localizations: Localizations? = nil
	) {
		self.comment = comment
		self.extractionState = extractionState
		self.localizations = localizations
	}
}
