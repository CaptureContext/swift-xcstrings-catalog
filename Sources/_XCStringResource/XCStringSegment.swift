import Foundation

public enum XCStringSegment: Equatable {
	case string(String)
	case interpolation(String)

	public var content: String {
		switch self {
		case let .string(value): value
		case let .interpolation(value): value
		}
	}
}
