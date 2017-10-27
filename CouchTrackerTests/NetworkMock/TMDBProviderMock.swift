import Moya
import TMDBSwift

let tmdbProviderMock = TMDBProviderMock()

final class TMDBProviderMock: TMDBProvider {
  var movies: RxMoyaProvider<Movies> {
    return RxMoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: RxMoyaProvider<Shows> {
    return RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var configuration: RxMoyaProvider<ConfigurationService> {
    return RxMoyaProvider<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var episodes: RxMoyaProvider<Episodes> {
    return RxMoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }
}
