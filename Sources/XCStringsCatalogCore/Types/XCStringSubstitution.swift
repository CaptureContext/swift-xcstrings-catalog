import Foundation

public struct XCStringSubstitution: Codable, Hashable, Sendable {
	public let argNum: Int
	public let formatSpecifier: String
	public let variations: XCStringVariations?

	public init(
		argNum: Int,
		formatSpecifier: String,
		variations: XCStringVariations?
	) {
		self.argNum = argNum
		self.formatSpecifier = formatSpecifier
		self.variations = variations
	}
}
