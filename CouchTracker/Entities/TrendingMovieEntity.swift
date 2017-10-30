import TraktSwift

struct TrendingMovieEntity: Hashable {
  let movie: MovieEntity

  var hashValue: Int {
    return movie.hashValue
  }

  static func == (lhs: TrendingMovieEntity, rhs: TrendingMovieEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
