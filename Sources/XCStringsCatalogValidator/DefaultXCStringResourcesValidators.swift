import _XCStringResource
import Dependencies

extension DependencyValues {
	private enum DefaultXCStringResourceValidatorKey: DependencyKey {
		public static var liveValue: any XCStringResourceValidator { .empty }
		public static var testValue: any XCStringResourceValidator { .empty }
	}

	public var defaultXCStringResourceValidator: any XCStringResourceValidator {
		get { self[DefaultXCStringResourceValidatorKey.self] }
		set { self[DefaultXCStringResourceValidatorKey.self] = newValue }
	}
}

extension DependencyValues {
	private enum DefaultXCStringResourcesValidatorKey: DependencyKey {
		public static var liveValue: any XCStringResourcesValidator {
			DefaultXCStringResourcesValidator()
		}
		public static var testValue: any XCStringResourcesValidator {
			DefaultXCStringResourcesValidator()
		}
	}

	public var defaultXCStringResourcesValidator: any XCStringResourcesValidator {
		get { self[DefaultXCStringResourcesValidatorKey.self] }
		set { self[DefaultXCStringResourcesValidatorKey.self] = newValue }
	}
}

public struct DefaultXCStringResourcesValidator: XCStringResourcesValidator {
	@Dependency(\.defaultXCStringResourceValidator)
	var defaultXCStringResourceValidator

	public init() {}

	public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
		resources.flatMap { defaultXCStringResourceValidator.validateResource($0) }
	}
}
