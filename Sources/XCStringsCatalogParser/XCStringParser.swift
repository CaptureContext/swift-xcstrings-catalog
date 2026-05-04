import Foundation
import RegexBuilder
import Dependencies

enum ParsedXCStringSegment: Equatable, Sendable {
	case string(contents: String)
	case placeholder(Placeholder)

	struct Placeholder: Equatable, Sendable {
		let rawValue: String
		let position: Int?
		let label: String?
		let type: String?

		init(
			rawValue: String,
			position: Int? = nil,
			label: String? = nil,
			type: String? = nil
		) {
			self.rawValue = rawValue
			self.position = position
			self.label = label
			self.type = type
		}
	}
}

protocol XCStringParser: Sendable {
	func parse(
		_ input: String,
		expandingSubstitutions substitutions: [String: String]
	) -> [ParsedXCStringSegment]
}

extension DependencyValues {
	private enum XCStringParserKey: DependencyKey {
		static var liveValue: any XCStringParser { DefaultXCStringParser() }
		static var testValue: any XCStringParser { DefaultXCStringParser() }
	}

	var xcStringParser: any XCStringParser {
		get { self[XCStringParserKey.self] }
		set { self[XCStringParserKey.self] = newValue }
	}
}

/// A helper for parsing a string value within a string catalog to extract placeholder and substitution markers
struct DefaultXCStringParser: XCStringParser {
	init() {}

	/// Parse the given input string including the expansion of the given substitutions
	func parse(
		_ input: String,
		expandingSubstitutions substitutions: [String: String]
	) -> [ParsedXCStringSegment] {
		var input = input
		for (key, value) in substitutions {
			input = input.replacingOccurrences(of: "%#@\(key)@", with: value)
		}

		return parse(input)
	}

	/// Parses the given input string into an array of segments
	private func parse(_ input: String) -> [ParsedXCStringSegment] {
		var segments: [ParsedXCStringSegment] = []
		var lastIndex = input.startIndex

		for match in input.matches(of: regex) {
			// Create a segment from the previous bound to here
			if match.range.lowerBound != lastIndex {
				let string = String(input[lastIndex ..< match.range.lowerBound])
				segments.append(.string(contents: string))
			}

			// Now create a segment for the match itself
			let output: (rawValue: Substring, position: Int?, label: String?, type: String?) = match.output
			segments.append(.placeholder(.init(
				rawValue: String(output.rawValue),
				position: output.position,
				label: output.label,
				type: output.type
			)))

			// Update the last index for the next iteration
			lastIndex = match.range.upperBound
		}

		// If there was more content after the last match, append it to the final output
		if input.endIndex != lastIndex {
			let string = String(input[lastIndex ..< input.endIndex])
			segments.append(.string(contents: string))
		}

		return segments
	}

	private var regex: Regex<Regex<(Substring, Int?, String?, String)>.RegexOutput> {
		Regex {
			// The start of the specifier
			"%"

			indexRegex
			labelRegex

			// Optional, precision information
			Optionally(.anyOf("-+"))
			Optionally(.digit)
			Optionally {
				"."
				One(.digit)
			}

			formatRegex
		}
	}

	private var indexRegex: some RegexComponent<(Substring, Int?)> {
		Optionally {
			TryCapture {
				OneOrMore(.digit)
			} transform: { rawValue in
				Int(rawValue)
			}
			"$"
		}
	}

	private var labelRegex: some RegexComponent<(Substring, String?)> {
		Optionally {
			"("
			Capture {
				OneOrMore(.word)
			} transform: { rawValue in
				String(rawValue)
			}
			")"
		}
	}

	private var formatRegex: some RegexComponent<(Substring, String)> {
		TryCapture {
			ChoiceOf {
				"%"
				"@"
				Regex {
					Optionally {
						ChoiceOf {
							"h"
							"hh"
							"l"
							"ll"
							"q"
							"z"
							"t"
							"j"
						}
					}
					One(.anyOf("diouxf"))
				}
				One(.anyOf("aefg"))
				One(.anyOf("csp"))
			}
		} transform: { rawValue in
			String(rawValue)
		}
	}
}
