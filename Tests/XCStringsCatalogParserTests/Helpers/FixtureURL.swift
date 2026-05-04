import Foundation

func fixtureURL(for name: String) throws -> URL {
	struct CouldntFindFixture: Error {
		var name: String

		init(_ name: String) {
			self.name = name
		}
	}

	let fixtureURL = Bundle.module.url(
		forResource: name,
		withExtension: "xcstrings",
		subdirectory: "__Fixtures__"
	)

	guard let fixtureURL
	else { throw CouldntFindFixture(name) }

	return fixtureURL
}
