import Foundation

public struct XCStringExtractionState:
	RawRepresentable,
	CodingKeyRepresentable,
	Codable,
	Hashable,
	Sendable
{
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public static let manual = Self(rawValue: "manual")
	public static let automatic = Self(rawValue: "automatic")
	public static let migrated = Self(rawValue: "migrated")
}

extension XCStringExtractionState: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(rawValue: value)
	}
}
