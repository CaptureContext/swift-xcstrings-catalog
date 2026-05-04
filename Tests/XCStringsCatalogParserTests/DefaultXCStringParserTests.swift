import Testing
@testable import XCStringsCatalogParser

@Suite
struct DefaultXCStringParserTests {
	@Test
	func parseSimpleLiteral() async throws {
		let sut = DefaultXCStringParser()
		#expect(sut.parse("lorem", expandingSubstitutions: [:]) == [.string(contents: "lorem")])
	}

	@Test
	func parseLiteralWithUnlabeledPlaceholders() async throws {
		let sut = DefaultXCStringParser()
		let input = "Lorem %@ ipsum %@ dolor %@ sit amet"
		#expect(
			sut.parse(input, expandingSubstitutions: [:])
			== [
				.string(contents: "Lorem "),
				.placeholder(.init(
					rawValue: "%@",
					type: "@"
				)),
				.string(contents: " ipsum "),
				.placeholder(.init(
					rawValue: "%@",
					type: "@"
				)),
				.string(contents: " dolor "),
				.placeholder(.init(
					rawValue: "%@",
					type: "@"
				)),
				.string(contents: " sit amet"),
			]
		)
	}

	@Test
	func parseLiteralWithUnlabeledIndexedPlaceholders() async throws {
		let sut = DefaultXCStringParser()
		let input = "Lorem %1$@ ipsum %2$@ dolor %3$@ sit amet"
		#expect(
			sut.parse(input, expandingSubstitutions: [:])
			== [
				.string(contents: "Lorem "),
				.placeholder(.init(
					rawValue: "%1$@",
					position: 1,
					type: "@"
				)),
				.string(contents: " ipsum "),
				.placeholder(.init(
					rawValue: "%2$@",
					position: 2,
					type: "@"
				)),
				.string(contents: " dolor "),
				.placeholder(.init(
					rawValue: "%3$@",
					position: 3,
					type: "@"
				)),
				.string(contents: " sit amet"),
			]
		)
	}

	@Test
	func parseLiteralWithLabeledIndexedPlaceholders() async throws {
		let sut = DefaultXCStringParser()
		let input = "Lorem %1$(first)@ ipsum %2$(second)@ dolor %3$(third)@ sit amet"
		#expect(
			sut.parse(input, expandingSubstitutions: [:])
			== [
				.string(contents: "Lorem "),
				.placeholder(.init(
					rawValue: "%1$(first)@",
					position: 1,
					label: "first",
					type: "@"
				)),
				.string(contents: " ipsum "),
				.placeholder(.init(
					rawValue: "%2$(second)@",
					position: 2,
					label: "second",
					type: "@"
				)),
				.string(contents: " dolor "),
				.placeholder(.init(
					rawValue: "%3$(third)@",
					position: 3,
					label: "third",
					type: "@"
				)),
				.string(contents: " sit amet"),
			]
		)
	}

	@Test
	func parseLiteralWithMixedlaceholders() async throws {
		let sut = DefaultXCStringParser()
		let input = "Lorem %1$(first)@ ipsum %@ dolor %@ sit amet"
		#expect(
			sut.parse(input, expandingSubstitutions: [:])
			== [
				.string(contents: "Lorem "),
				.placeholder(.init(
					rawValue: "%1$(first)@",
					position: 1,
					label: "first",
					type: "@"
				)),
				.string(contents: " ipsum "),
				.placeholder(.init(
					rawValue: "%@",
					type: "@"
				)),
				.string(contents: " dolor "),
				.placeholder(.init(
					rawValue: "%@",
					type: "@"
				)),
				.string(contents: " sit amet"),
			]
		)
	}

	@Test
	func parseLiteralWithNumericPlaceholders() async throws {
			let sut = DefaultXCStringParser()
			let input = "Lorem %1$lld ipsum %2$llu dolor %3$lf sit amet"
			#expect(
				sut.parse(input, expandingSubstitutions: [:])
				== [
					.string(contents: "Lorem "),
					.placeholder(.init(
						rawValue: "%1$lld",
						position: 1,
						type: "lld"
					)),
					.string(contents: " ipsum "),
					.placeholder(.init(
						rawValue: "%2$llu",
						position: 2,
						type: "llu"
					)),
					.string(contents: " dolor "),
					.placeholder(.init(
						rawValue: "%3$lf",
						position: 3,
						type: "lf"
					)),
					.string(contents: " sit amet"),
				]
			)
	}
}
