import TraktSwift

extension Show {
  public func genres(for genres: [Genre]) -> [Genre] {
    guard let showGenres = self.genres else { return [Genre]() }
    return genres.filter { showGenres.contains($0.slug) }
  }
}
