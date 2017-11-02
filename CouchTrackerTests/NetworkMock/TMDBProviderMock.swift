import Moya
import TMDBSwift

let tmdbProviderMock = TMDBProviderMock()

final class TMDBProviderMock: TMDBProvider {
  var movies: MoyaProvider<Movies> {
    return MoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: MoyaProvider<Shows> {
    return MoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var configuration: MoyaProvider<ConfigurationService> {
    return MoyaProvider<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var episodes: MoyaProvider<Episodes> {
    return MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }
}
