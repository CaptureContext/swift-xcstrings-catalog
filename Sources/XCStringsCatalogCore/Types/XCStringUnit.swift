import Foundation

public struct XCStringUnit: Codable, Hashable, Sendable {
	public var state: XCStringUnitState
	public var value: String

	public init(
		state: XCStringUnitState,
		value: String
	) {
		self.state = state
		self.value = value
	}
}
