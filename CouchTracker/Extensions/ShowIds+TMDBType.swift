import TraktSwift

extension ShowIds {
	func tmdbModelType() -> TrendingViewModelType? {
		var type: TrendingViewModelType? = nil
		if let tmdbId = self.tmdb {
			type = TrendingViewModelType.show(tmdbShowId: tmdbId)
		}
		return type
	}
}
