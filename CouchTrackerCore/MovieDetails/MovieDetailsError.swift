public enum MovieDetailsError: Error, Hashable {
	case noImageAvailable
	case noConnection(String)
	case parseError(String)

	public var message: String {
		switch self {
		case .noConnection(let message), .parseError(let message):
			return message
		default:
			return self.localizedDescription
		}
	}

	public static func == (lhs: MovieDetailsError, rhs: MovieDetailsError) -> Bool {
		return lhs.message == rhs.message
	}
}
