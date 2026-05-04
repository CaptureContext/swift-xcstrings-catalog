import _XCStringResource
import _XCStringsSource
import Dependencies
import XCStringsCatalogCore

public struct XCStringsCatalogParserOutput: Equatable, Sendable {
	public let resources: [XCStringResource]
	public let issues: [ExtractionIssue]

	public init(
		resources: [XCStringResource],
		issues: [ExtractionIssue]
	) {
		self.resources = resources
		self.issues = issues
	}
}

public protocol XCStringsCatalogParser: Sendable {
	func parse(
		from source: XCStringsSource
	) throws -> XCStringsCatalogParserOutput
}

extension DependencyValues {
	private enum DefaultXCStringParserKey: DependencyKey {
		static var liveValue: any XCStringsCatalogParser { DefaultXCStringsCatalogParser() }
		static var testValue: any XCStringsCatalogParser { DefaultXCStringsCatalogParser() }
	}

	public var xcStringsCatalogParser: any XCStringsCatalogParser {
		get { self[DefaultXCStringParserKey.self] }
		set { self[DefaultXCStringParserKey.self] = newValue }
	}
}

public struct DefaultXCStringsCatalogParser: XCStringsCatalogParser {
	public typealias Output = XCStringsCatalogParserOutput

	public init() {}

	@inlinable
	public func parse(
		from source: XCStringsSource
	) throws -> XCStringsCatalogParserOutput {
		switch source {
		case let .catalog(stringCatalog):
			try extractResources(from: stringCatalog)
		case let .legacy(legacyFormat):
			try extractResources(from: legacyFormat)
		}
	}
}

extension XCStringsCatalog {
	public func parse() throws -> XCStringsCatalogParserOutput {
		@Dependency(\.xcStringsCatalogParser)
		var parser

		return try parser.parse(from: .catalog(self))
	}
}
