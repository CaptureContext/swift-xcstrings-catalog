extension XCStringResource {
	public enum PlaceholderType: String, CaseIterable, Sendable {
		case int
		case uint
		case float
		case double
		case object
	}
}
