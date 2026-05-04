import Foundation

public struct XCStringLocalization: Codable, Hashable, Sendable {
	public var stringUnit: XCStringUnit?
	public var substitutions: [String: XCStringSubstitution]?
	public var variations: XCStringVariations?

	public init(
		stringUnit: XCStringUnit? = nil,
		substitutions: [String : XCStringSubstitution]? = nil,
		variations: XCStringVariations? = nil
	) {
		self.stringUnit = stringUnit
		self.substitutions = substitutions
		self.variations = variations
	}
}
