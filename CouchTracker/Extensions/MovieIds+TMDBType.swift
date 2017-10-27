import Trakt

extension MovieIds {
  func tmdbModelType() -> TrendingViewModelType? {
    var type: TrendingViewModelType? = nil
    if let tmdbId = self.tmdb {
      type = TrendingViewModelType.movie(tmdbMovieId: tmdbId)
    }
    return type
  }
}
