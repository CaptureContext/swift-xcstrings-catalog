import _XCStringResource

public enum XCStringResourcesValidators {}

extension XCStringResourcesValidators {
	public struct AnyValidator: XCStringResourcesValidator {
		@usableFromInline
		internal let underlying: any XCStringResourcesValidator

		public init(_ underlying: any XCStringResourcesValidator) {
			self.underlying = underlying
		}

		@inlinable
		public init(_ validate: @escaping @Sendable ([XCStringResource]) -> [XCStringResourceIssue]) {
			self.init(.inline(validate))
		}

		@inlinable
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			underlying.validateResources(resources)
		}
	}
}

extension XCStringResourcesValidators {
	public struct Empty: XCStringResourcesValidator {
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			return []
		}
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.Empty {
	public static var empty: Self { .init()  }
}

extension XCStringResourcesValidators {
	public struct Inline: XCStringResourcesValidator {
		@usableFromInline
		internal let validate: @Sendable ([XCStringResource]) -> [XCStringResourceIssue]

		public init(_ validate: @escaping @Sendable ([XCStringResource]) -> [XCStringResourceIssue]) {
			self.validate = validate
		}

		@inlinable
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			validate(resources)
		}
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.Inline {
	@inlinable
	public static func inline(
		_ validate: @escaping @Sendable (
			[XCStringResource]
		) -> [XCStringResourceIssue]
	) -> Self {
		return .init(validate)
	}
}

extension XCStringResourcesValidators {
	public struct Concat: XCStringResourcesValidator {
		@usableFromInline
		internal let validators: [any XCStringResourcesValidator]

		public init(_ validators: [any XCStringResourcesValidator]) {
			self.validators = validators
		}

		@inlinable
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			validators.flatMap { $0.validateResources(resources) }
		}
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.Concat {
	@inlinable
	public static func concatenate(
		_ validators: (any XCStringResourcesValidator)...
	) -> Self {
		return .init(validators)
	}

	@inlinable
	public static func concatenate(
		_ validators: [any XCStringResourcesValidator]
	) -> Self {
		return .init(validators)
	}
}

extension XCStringResourcesValidator {
	@inlinable
	public func appending(
		_ validators: (any XCStringResourcesValidator)...
	) -> some XCStringResourcesValidator {
		return .concatenate([self] + validators)
	}
}
