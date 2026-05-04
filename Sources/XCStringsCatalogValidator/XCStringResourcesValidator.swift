import _XCStringResource

public protocol XCStringResourcesValidator: Sendable {
	func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue]
}
