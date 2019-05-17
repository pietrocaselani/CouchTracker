import CouchTrackerCore
import TraktSwift
import TraktSwiftTestable

final class TraktEntitiesMock {
  static var jsonDecoder: JSONDecoder {
    return JSONDecoder()
  }

  static func createSearchResultsMock() -> [SearchResult] {
    let data = Search.textQuery(types: [.movie], query: "Tron", page: 0, limit: 100).sampleData

    return try! jsonDecoder.decode([SearchResult].self, from: data)
  }

  static func createSearchResultEntitiesMock() -> [SearchResultEntity] {
    let data = Search.textQuery(types: [.movie], query: "Tron", page: 0, limit: 100).sampleData

    return try! jsonDecoder.decode([SearchResult].self, from: data).compactMap { result in
      let type: SearchResultType
      switch result.type {
      case .movie:
        type = result.movie.map(SearchResultType.movie(movie:))!
      case .show:
        type = result.show.map(SearchResultType.show(show:))!
      default:
        return nil
      }

      return SearchResultEntity(score: result.score, type: type)
    }
  }

  static func createMoviesGenresMock() -> [Genre] {
    return try! jsonDecoder.decode([Genre].self, from: Genres.list(.movies).sampleData)
  }

  static func createShowsGenresMock() -> [Genre] {
    return try! jsonDecoder.decode([Genre].self, from: Genres.list(.shows).sampleData)
  }

  static func createTrendingShowsMock() -> [TrendingShow] {
    return try! jsonDecoder.decode([TrendingShow].self, from: Shows.trending(page: 0, limit: 10, extended: .full).sampleData)
  }

  static func createTrendingMoviesMock() -> [TrendingMovie] {
    return try! jsonDecoder.decode([TrendingMovie].self, from: Movies.trending(page: 0, limit: 10, extended: .full).sampleData)
  }

  static func createMockMovies() -> [TrendingMovie] {
    return try! jsonDecoder.decode([TrendingMovie].self, from: Movies.trending(page: 0, limit: 50, extended: .full).sampleData)
  }

  static func createMovieMock(for movieId: String) -> Movie {
    let movies = createMockMovies()

    let trendingMovie = movies.first { $0.movie.ids.slug == movieId }

    return trendingMovie?.movie ?? createMovieDetailsMock(for: movieId)
  }

  static func createMovieDetailsMock(for movieId: String) -> Movie {
    let data = Movies.summary(movieId: movieId, extended: .full).sampleData
    return try! jsonDecoder.decode(Movie.self, from: data)
  }

  static func createUnwatchedMovieDetailsMock() -> Movie {
    return try! TraktTestableBundle.decode(resource: "trakt_unwatched_movie_summary")!
  }

  static func endedAndCompletedShow() -> WatchedShowEntity {
    return try! TraktTestableBundle.decode(resource: "trakt_show_ended_completed")!
  }

  static func createMovieDetailsMock() -> Movie {
    return createMovieDetailsMock(for: "tron-legacy-2010")
  }

  static func createTraktShowDetails() -> Show {
    return try! jsonDecoder.decode(Show.self, from: Shows.summary(showId: "game-of-thrones", extended: .full).sampleData)
  }

  static func createUserSettingsMock() -> Settings {
    return try! jsonDecoder.decode(Settings.self, from: Users.settings.sampleData)
  }
}
