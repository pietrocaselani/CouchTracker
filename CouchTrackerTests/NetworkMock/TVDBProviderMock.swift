import Moya
import TVDBSwift

let tvdbProviderMock = TVDBProviderMock()

final class TVDBProviderMock: TVDBProvider {
  var episodes: MoyaProvider<Episodes> {
    return MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }
}
