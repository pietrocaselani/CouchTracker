import TraktSwift

extension ShowIds {
  func tmdbModelType() -> PosterViewModelType? {
    var type: PosterViewModelType?
    if let tmdbId = self.tmdb {
      type = PosterViewModelType.show(tmdbShowId: tmdbId)
    }
    return type
  }
}
