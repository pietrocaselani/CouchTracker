import TMDBSwift
import Moya

final class TMDBWrapperProvider: TMDBProvider {
  private let tmdb: TMDB

  var movies: MoyaProvider<Movies>

  var shows: MoyaProvider<Shows>

  var configuration: MoyaProvider<ConfigurationService>

  var episodes: MoyaProvider<Episodes>

  init(tmdb: TMDB) {
    self.tmdb = tmdb

    self.movies = tmdb.movies
    self.shows = tmdb.shows
    self.configuration = tmdb.configuration
    self.episodes = tmdb.episodes
  }
}
