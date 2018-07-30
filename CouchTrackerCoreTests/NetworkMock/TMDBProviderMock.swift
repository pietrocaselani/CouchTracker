@testable import CouchTrackerCore
import Moya
import TMDBSwift

let tmdbProviderMock = TMDBProviderMock()

final class TMDBProviderMock: TMDBProvider {
    var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
    var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>(stubClosure: MoyaProvider.immediatelyStub)
    var configuration: MoyaProvider<ConfigurationService> = MoyaProviderMock<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)
    var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
}
