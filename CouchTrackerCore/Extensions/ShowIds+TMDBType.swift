import TraktSwift

extension ShowIds {
	func tmdbModelType() -> PosterViewModelType? {
		var type: PosterViewModelType? = nil
		if let tmdbId = self.tmdb {
			type = PosterViewModelType.show(tmdbShowId: tmdbId)
		}
		return type
	}
}
