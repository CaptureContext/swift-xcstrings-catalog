import Foundation

public struct XCStringLanguage:
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

	public static let english = Self(rawValue: "en")
}

extension XCStringLanguage: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self.init(rawValue: value)
	}
}
