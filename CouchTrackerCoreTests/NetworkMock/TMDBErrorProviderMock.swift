@testable import CouchTrackerCore
import Moya
import TMDBSwift

final class TMDBErrorProviderMock: TMDBProvider {
    var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
    var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>(stubClosure: MoyaProvider.immediatelyStub)
    var configuration: MoyaProvider<ConfigurationService> = MoyaProviderMock<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)

    lazy var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(endpointClosure: createEpisodesEndpointClosure(),
                                                                           stubClosure: MoyaProvider.immediatelyStub)

    private func createEpisodesEndpointClosure() -> MoyaProvider<Episodes>.EndpointClosure {
        let endpointClosure = { (_: Episodes) -> Endpoint in
            Endpoint(url: "http://fakeurl.com", sampleResponseClosure: { () -> EndpointSampleResponse in
                .networkResponse(404, Data())
            }, method: Moya.Method.get, task: Task.requestPlain, httpHeaderFields: nil)
        }

        return endpointClosure
    }
}
