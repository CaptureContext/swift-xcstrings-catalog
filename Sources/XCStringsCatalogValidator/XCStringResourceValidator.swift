import _XCStringResource

public protocol XCStringResourceValidator: Sendable {
	func validateResource(_ resource: XCStringResource) -> [XCStringResourceIssue]
}
