enum TrendingViewModelType: Hashable {
	case show(tmdbShowId: Int)
	case movie(tmdbMovieId: Int)

	var hashValue: Int {
		switch self {
		case .movie(let tmdbMovieId):
			return "movie".hashValue ^ tmdbMovieId.hashValue
		case .show(let tmdbShowId):
			return "show".hashValue ^ tmdbShowId.hashValue
		}
	}

	static func == (lhs: TrendingViewModelType, rhs: TrendingViewModelType) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}

struct TrendingViewModel: Hashable {
	let title: String
	let type: TrendingViewModelType?

	static func == (lhs: TrendingViewModel, rhs: TrendingViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	var hashValue: Int {
		var hash = title.hashValue

		if let typeHash = type?.hashValue {
			hash = hash ^ typeHash
		}

		return hash
	}
}
