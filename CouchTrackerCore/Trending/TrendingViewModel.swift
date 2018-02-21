public enum TrendingViewModelType: Hashable {
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

	public static func == (lhs: TrendingViewModelType, rhs: TrendingViewModelType) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}

public struct TrendingViewModel: Hashable {
	public let title: String
	public let type: TrendingViewModelType?

	public static func == (lhs: TrendingViewModel, rhs: TrendingViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	public var hashValue: Int {
		var hash = title.hashValue

		if let typeHash = type?.hashValue {
			hash = hash ^ typeHash
		}

		return hash
	}
}
