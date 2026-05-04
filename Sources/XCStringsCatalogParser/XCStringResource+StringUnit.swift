import Foundation
import XCStringsCatalogCore
import _XCStringResource
import Dependencies

extension XCStringResource {
	init(
		key: String,
		comment: String?,
		sourceLocalization: XCStringLocalization
	) throws {
		let extracted = try Self.extract(from: sourceLocalization, key: key)

		self.init(
			key: key,
			comment: comment,
			arguments: extracted.arguments,
			sourceLocalization: extracted.sourceLocalization
		)
	}

	static func extract(
		from localization: XCStringLocalization,
		key: String
	) throws -> (arguments: [XCStringResource.Argument], sourceLocalization: String) {
		guard let stringUnit = preferredStringUnit(from: localization.stringUnit, variations: localization.variations) else {
			throw ExtractionError.localizationCorrupt(
				ExtractionError.Context(
					key: key,
					debugDescription: "A base string unit could not be found."
				)
			)
		}

		let substitutions = try localization.substitutions?.mapValues { substitution in
			guard let stringUnit = preferredStringUnit(from: nil, variations: substitution.variations) else {
				throw ExtractionError.localizationCorrupt(
					ExtractionError.Context(
						key: key,
						debugDescription: "A base string unit could not be found for the substitution."
					)
				)
			}

			return stringUnit.value.replacingOccurrences(of: "%arg", with: "%\(substitution.formatSpecifier)")
		}

		@Dependency(\.xcStringParser)
		var xcStringParser

		// Parse the raw segments
		let segments = xcStringParser.parse(
			stringUnit.value,
			expandingSubstitutions: substitutions ?? [:]
		)

		// Calculate labels from substitutions
		let labelSequence = localization.substitutions?.map {
			($0.value.argNum, $0.key)
		}
		let labels = Dictionary(uniqueKeysWithValues: labelSequence ?? [])

		// Convert the parsed arguments and labels into the correct data
		return try extract(from: segments, labels: labels, key: key)
	}

	private static func preferredStringUnit(
		from stringUnit: XCStringUnit?,
		variations: XCStringVariations?
	) -> XCStringUnit? {
		if let stringUnit {
			return stringUnit
		}

		if let deviceVariation = variations?.device?.preferredDeviceVariation {
			return deviceVariation.stringUnit
		}

		if let pluralVariation = variations?.plural?.preferredPluralVariation {
			return pluralVariation.stringUnit
		}

		return nil
	}
}

private extension Dictionary where
	Key == XCStringVariations.DeviceKey,
	Value == XCStringVariation
{
	var preferredDeviceVariation: XCStringVariation? {
		self[.other] ?? self.values.first
	}
}

private extension Dictionary where
	Key == XCStringVariations.PluralKey,
	Value == XCStringVariation
{
	var preferredPluralVariation: XCStringVariation? {
		self[.other] ?? self[.one] ?? self.values.first
	}
}
