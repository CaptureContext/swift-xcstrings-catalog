import XCStringsCatalogCore

public struct ExtractionIssue: Equatable, Sendable {
	public enum Reason: Equatable, Sendable {
		case wrongExtractionState(XCStringExtractionState?)
		case missingSourceLocalization(XCStringLanguage)
	}
	
	public let key: String
	public let reason: Reason
	
	public var description: String {
		switch reason {
		case let .wrongExtractionState(state):
			"String ‘\(key)‘ was ignored because it is not managed manually (\(state?.rawValue ?? "nil"))"
		case let .missingSourceLocalization(language):
			"String ‘\(key)‘ was ignored because it does not have a translation for source language (\(language.rawValue))"
		}
	}
}
