@testable import CouchTrackerCore
import Moya
import TMDBSwift

let tmdbProviderMock = TMDBProviderMock()

func createTMDBProviderMock(error: Error? = nil) -> TMDBProviderMock {
  return TMDBProviderMock(error: error)
}

final class TMDBProviderMock: TMDBProvider {
  lazy var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>.createProvider(error: error, target: Movies.self)
  lazy var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>.createProvider(error: error, target: Shows.self)
  lazy var configuration: MoyaProvider<ConfigurationService> = MoyaProviderMock<ConfigurationService>.createProvider(error: error, target: ConfigurationService.self)
  lazy var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>.createProvider(error: error, target: Episodes.self)

  private let error: Error?

  init(error: Error? = nil) {
    self.error = error
  }
}
