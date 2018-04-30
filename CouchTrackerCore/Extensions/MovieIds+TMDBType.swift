import TraktSwift

extension MovieIds {
	func tmdbModelType() -> PosterViewModelType? {
		var type: PosterViewModelType? = nil
		if let tmdbId = self.tmdb {
			type = PosterViewModelType.movie(tmdbMovieId: tmdbId)
		}
		return type
	}
}
