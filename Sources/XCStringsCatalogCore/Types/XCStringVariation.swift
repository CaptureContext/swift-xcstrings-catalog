import Foundation

public struct XCStringVariation: Codable, Hashable, Sendable {
	public var stringUnit: XCStringUnit

	public init(stringUnit: XCStringUnit) {
		self.stringUnit = stringUnit
	}
}
