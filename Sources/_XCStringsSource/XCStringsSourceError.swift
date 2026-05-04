import Foundation

public enum XCStringsSourceError: LocalizedError {
	case invalidFileFormat(String)
	case invalidPropertyListContents

	public var errorDescription: String? {
		switch self {
		case let .invalidFileFormat(format):
			"The file format ‘\(format)‘ is not supported."
		case .invalidPropertyListContents:
			"The root object of the property list was not a dictionary."
		}
	}
}
