import Moya
import TVDBSwift
@testable import CouchTrackerCore

let tvdbProviderMock = TVDBProviderMock()

final class TVDBProviderMock: TVDBProvider {
	var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
}
