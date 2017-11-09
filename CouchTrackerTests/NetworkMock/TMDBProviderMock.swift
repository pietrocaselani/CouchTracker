import Moya
import TMDBSwift

let tmdbProviderMock = TMDBProviderMock()

final class TMDBProviderMock: TMDBProvider {
  var movies: MoyaProvider<Movies> = MoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  var shows: MoyaProvider<Shows> = MoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  var configuration: MoyaProvider<ConfigurationService> = MoyaProvider<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)
  var episodes: MoyaProvider<Episodes> = MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
}
