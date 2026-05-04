import _XCStringResource

public struct XCStringResourceIssue: Equatable, Sendable {
	public let resources: [XCStringResource]
	public let description: String

	public init(
		resources: [XCStringResource],
		description: String
	) {
		self.resources = resources
		self.description = description
	}
}
