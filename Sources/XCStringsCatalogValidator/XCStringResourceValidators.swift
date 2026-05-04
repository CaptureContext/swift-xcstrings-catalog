import _XCStringResource

public enum XCStringResourceValidators {}

extension XCStringResourceValidators {
	public struct AnyValidator: XCStringResourceValidator {
		@usableFromInline
		internal let underlying: any XCStringResourceValidator

		public init(_ underlying: any XCStringResourceValidator) {
			self.underlying = underlying
		}

		@inlinable
		public init(_ validate: @escaping @Sendable (XCStringResource) -> [XCStringResourceIssue]) {
			self.init(.inline(validate))
		}

		@inlinable
		public func validateResource(_ resource: XCStringResource) -> [XCStringResourceIssue] {
			underlying.validateResource(resource)
		}
	}
}

extension XCStringResourceValidators {
	public struct Empty: XCStringResourceValidator {
		public func validateResource(_ resource: XCStringResource) -> [XCStringResourceIssue] {
			return []
		}
	}
}

extension XCStringResourceValidator where Self == XCStringResourceValidators.Empty {
	public static var empty: Self { .init()  }
}

extension XCStringResourceValidators {
	public struct Inline: XCStringResourceValidator {
		@usableFromInline
		internal let validate: @Sendable (XCStringResource) -> [XCStringResourceIssue]

		public init(_ validate: @escaping @Sendable (XCStringResource) -> [XCStringResourceIssue]) {
			self.validate = validate
		}

		@inlinable
		public func validateResource(_ resource: XCStringResource) -> [XCStringResourceIssue] {
			validate(resource)
		}
	}
}

extension XCStringResourceValidator where Self == XCStringResourceValidators.Inline {
	@inlinable
	public static func inline(
		_ validate: @escaping @Sendable (
			XCStringResource
		) -> [XCStringResourceIssue]
	) -> Self {
		return .init(validate)
	}
}

extension XCStringResourceValidators {
	public struct Concat: XCStringResourceValidator {
		@usableFromInline
		internal let validators: [any XCStringResourceValidator]

		public init(_ validators: [any XCStringResourceValidator]) {
			self.validators = validators
		}

		@inlinable
		public func validateResource(_ resource: XCStringResource) -> [XCStringResourceIssue] {
			validators.flatMap { $0.validateResource(resource) }
		}
	}
}

extension XCStringResourceValidator where Self == XCStringResourceValidators.Concat {
	@inlinable
	public static func concatenate(
		_ validators: (any XCStringResourceValidator)...
	) -> Self {
		return .init(validators)
	}

	@inlinable
	public static func concatenate(
		_ validators: [any XCStringResourceValidator]
	) -> Self {
		return .init(validators)
	}
}

extension XCStringResourceValidator {
	@inlinable
	public func appending(
		_ validators: (any XCStringResourceValidator)...
	) -> some XCStringResourceValidator {
		return .concatenate([self] + validators)
	}
}
