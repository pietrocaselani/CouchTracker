import Foundation
import TraktSwift

public final class MovieEntityMapper {
  private init() {}

  public static func entity(for movie: Movie, with genres: [Genre]? = nil, watchedAt: Date? = nil) -> MovieEntity {
    return MovieEntity(ids: movie.ids,
                       title: movie.title,
                       genres: genres,
                       tagline: movie.tagline,
                       overview: movie.overview,
                       releaseDate: movie.released,
                       watchedAt: watchedAt)
  }

  public static func entity(for trendingMovie: TrendingMovie, with genres: [Genre]? = nil) -> TrendingMovieEntity {
    let movie = entity(for: trendingMovie.movie, with: genres)
    return TrendingMovieEntity(movie: movie)
  }
}
