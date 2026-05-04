import Foundation

public struct XCStringResource: Hashable, Sendable, Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.key.localizedStandardCompare(rhs.key) == .orderedAscending
	}

	/// The original key defined in the String Catalog
	public let key: String
	
	/// The comment provided in the String Catalog, or nil if one was not set
	public let comment: String?
	
	/// An array of arguments to be interpolated into the resource
	public let arguments: [Argument]
	
	/// The source localization value
	public let sourceLocalization: String
	
	public init(
		key: String,
		comment: String?,
		arguments: [Argument],
		sourceLocalization: String
	) {
		self.key = key
		self.comment = comment
		self.arguments = arguments
		self.sourceLocalization = sourceLocalization
	}
}
