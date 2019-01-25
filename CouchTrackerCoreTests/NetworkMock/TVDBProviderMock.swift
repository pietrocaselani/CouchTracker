@testable import CouchTrackerCore
import Moya
import TVDBSwift

let tvdbProviderMock = TVDBProviderMock()

func createTVDBProviderMock(error: Error? = nil) -> TVDBProviderMock {
  return TVDBProviderMock(error: error)
}

final class TVDBProviderMock: TVDBProvider {
  lazy var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>.createProvider(error: error, target: Episodes.self)

  private let error: Error?

  init(error: Error? = nil) {
    self.error = error
  }
}
