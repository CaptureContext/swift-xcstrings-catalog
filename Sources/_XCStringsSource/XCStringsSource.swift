import Foundation
import XCStringsCatalogCore

/// Various sources of localized strings
public enum XCStringsSource {
	case catalog(Catalog)
	case legacy(LegacyFormat)
}

extension XCStringsSource {
	public typealias Catalog = XCStringsCatalog

	/// A representation of a raw .strings or .stringsdict file
	public typealias LegacyFormat = [String: Any]
}

// MARK: - Loading
extension XCStringsSource {
	public init(contentsOf fileURL: URL) throws {
		switch fileURL.pathExtension {
		case "xcstrings":
			self = try .catalog(Catalog(contentsOf: fileURL))
		case "stringsdict", "strings":
			self = try .legacy(LegacyFormat(contentsOf: fileURL))
		default:
			throw XCStringsSourceError.invalidFileFormat(fileURL.pathExtension)
		}
	}
}

// MARK: - Legacy Format
extension XCStringsSource.LegacyFormat {
	init(contentsOf fileURL: URL) throws {
		let data = try Data(contentsOf: fileURL)
		let plist = try PropertyListSerialization.propertyList(from: data, format: nil)

		if let dictionary = plist as? XCStringsSource.LegacyFormat {
			self = dictionary
		} else {
			throw XCStringsSourceError.invalidPropertyListContents
		}
	}
}
