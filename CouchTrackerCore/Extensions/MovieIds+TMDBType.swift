import TraktSwift

extension MovieIds {
  func tmdbModelType() -> PosterViewModelType? {
    var type: PosterViewModelType?
    if let tmdbId = self.tmdb {
      type = PosterViewModelType.movie(tmdbMovieId: tmdbId)
    }
    return type
  }
}
