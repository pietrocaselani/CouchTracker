import Moya
import TVDBSwift

let tvdbProviderMock = TVDBProviderMock()

final class TVDBProviderMock: TVDBProvider {
  var episodes: RxMoyaProvider<Episodes> {
    return RxMoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }
}
