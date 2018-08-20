import TraktSwift

extension Movie {
  public func genres(for genres: [Genre]) -> [Genre] {
    guard let movieGenres = self.genres else { return [Genre]() }
    return genres.filter { movieGenres.contains($0.slug) }
  }
}
