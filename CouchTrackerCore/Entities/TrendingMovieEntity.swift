public struct TrendingMovieEntity: Hashable {
  public let movie: MovieEntity

  public var hashValue: Int {
    return movie.hashValue
  }

  public static func == (lhs: TrendingMovieEntity, rhs: TrendingMovieEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
