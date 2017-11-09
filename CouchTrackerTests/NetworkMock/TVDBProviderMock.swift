import Moya
import TVDBSwift

let tvdbProviderMock = TVDBProviderMock()

final class TVDBProviderMock: TVDBProvider {
  var episodes: MoyaProvider<Episodes> = MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
}
