import Foundation

public struct XCStringsCatalog: Codable, Hashable, Sendable {
	public var sourceLanguage: XCStringLanguage
	public var strings: [String: XCStringEntry]
	public var version: String

	public init(
		sourceLanguage: XCStringLanguage,
		strings: [String : XCStringEntry],
		version: String
	) {
		self.sourceLanguage = sourceLanguage
		self.strings = strings
		self.version = version
	}
}

// MARK: - Init
extension XCStringsCatalog {
	public init(contentsOf fileURL: URL) throws {
		let data = try Data(contentsOf: fileURL)

		let decoder = JSONDecoder()
		self = try decoder.decode(Self.self, from: data)
	}
}
