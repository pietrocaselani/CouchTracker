import TraktSwift
import Foundation

final class MovieEntityMapper {
	private init() {}

	static func entity(for movie: Movie, with genres: [Genre]? = nil) -> MovieEntity {
		return MovieEntity(ids: movie.ids, title: movie.title, genres: genres,
											tagline: movie.tagline, overview: movie.overview, releaseDate: movie.released)
	}

	static func entity(for trendingMovie: TrendingMovie,
																				with genres: [Genre]? = nil) -> TrendingMovieEntity {
		let movie = entity(for: trendingMovie.movie, with: genres)
		return TrendingMovieEntity(movie: movie)
	}
}
