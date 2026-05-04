import Foundation

public struct XCStringUnitState: RawRepresentable, Codable, Hashable, Sendable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public static let translated = Self(rawValue: "translated")
	public static let needsReview = Self(rawValue: "needs_review")
}

extension XCStringUnitState: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(rawValue: value)
	}
}
