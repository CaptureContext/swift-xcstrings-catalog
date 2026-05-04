import Foundation
import _XCStringResource

extension XCStringResourcesValidators {
	public struct ConflictingIdentifiers: XCStringResourcesValidator {
		@usableFromInline
		internal let identifier: @Sendable (XCStringResource) -> String

		public init(_ identifier: @escaping @Sendable (XCStringResource) -> String) {
			self.identifier = identifier
		}

		@inlinable
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			Dictionary(grouping: resources, by: identifier)
				.filter { $0.value.count > 1 }
				.mapValues { resources in
					(
						resources: resources,
						keys: resources
							.map { "‘\($0.key)‘" }
							.formatted(.list(type: .and))
					)
				}
				.map { id, collection in
					XCStringResourceIssue(
						resources: collection.resources,
						description: "The keys \(collection.keys) produce the same identifier ‘\(id)‘."
					)
				}
		}
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.ConflictingIdentifiers {
	public static func conflictingIdentifiers(
		by identifier: @escaping @Sendable (XCStringResource) -> String
	) -> Self {
		XCStringResourcesValidators.ConflictingIdentifiers(identifier)
	}
}

extension XCStringResourcesValidators {
	public struct UnsupportedIdentifiers: XCStringResourcesValidator {
		@usableFromInline
		internal let identifier: @Sendable (XCStringResource) -> String

		public init(_ identifier: @escaping @Sendable (XCStringResource) -> String) {
			self.identifier = identifier
		}

		@inlinable
		public func validateResources(_ resources: [XCStringResource]) -> [XCStringResourceIssue] {
			resources
				.filter { identifier($0).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
				.map { resource in
					XCStringResourceIssue(
						resources: [resource],
						description: "The key ‘\(resource.key)‘ is not convertible to Swift identifier."
					)
				}
		}
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.UnsupportedIdentifiers {
	public static func unsupportedIdentifiers(
		by identifier: @escaping @Sendable (XCStringResource) -> String
	) -> Self {
		XCStringResourcesValidators.UnsupportedIdentifiers(identifier)
	}
}

extension XCStringResourcesValidator where Self == XCStringResourcesValidators.Concat {
	public static func defaultIdentifiersValidator(
		for identifier: @escaping @Sendable (XCStringResource) -> String
	) -> Self {
		.concatenate(
			.conflictingIdentifiers(by: identifier),
			.unsupportedIdentifiers(by: identifier),
		)
	}
}
