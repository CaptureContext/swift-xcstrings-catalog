import Foundation

public enum ExtractionError: Sendable, Error {
	public struct Context: Sendable {
		/// The key of the localization being parsed
		public let key: String

		/// A description of the issue
		public let debugDescription: String
	}

	case localizationCorrupt(Context)
	case unsupported(Context)
}

extension ExtractionError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case let .localizationCorrupt(context):
			"String ‘\(context.key)‘ was corrupt: \(context.debugDescription)"
		case let .unsupported(context):
			"String ‘\(context.key)‘ is not supported: \(context.debugDescription)"
		}
	}
}
