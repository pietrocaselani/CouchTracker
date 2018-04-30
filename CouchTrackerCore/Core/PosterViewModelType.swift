public enum PosterViewModelType: Hashable {
	case show(tmdbShowId: Int)
	case movie(tmdbMovieId: Int)

	public var hashValue: Int {
		switch self {
		case .movie(let tmdbMovieId):
			return "movie".hashValue ^ tmdbMovieId.hashValue
		case .show(let tmdbShowId):
			return "show".hashValue ^ tmdbShowId.hashValue
		}
	}

	public static func == (lhs: PosterViewModelType, rhs: PosterViewModelType) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
