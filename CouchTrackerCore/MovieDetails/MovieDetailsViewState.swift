public enum MovieDetailsViewState: Hashable {
	case loading
	case showing(movie: MovieEntity)
	case error(error: Error)

	public var hashValue: Int {
		switch self {
		case .loading:
			return "MovieDetailsViewState.loading".hashValue
		case .showing(let movie):
			return "MovieDetailsViewState.showing".hashValue ^ movie.hashValue
		case .error(let error):
			return "MovieDetailsViewState.error".hashValue ^ error.localizedDescription.hashValue
		}
	}

	public static func == (lhs: MovieDetailsViewState, rhs: MovieDetailsViewState) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
