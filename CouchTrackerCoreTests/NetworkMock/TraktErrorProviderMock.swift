@testable import CouchTrackerCore
import Moya
import RxSwift
import TraktSwift

final class TraktErrorProviderMock: TraktProvider {
    func finishesAuthentication(with _: URLRequest) -> Single<AuthenticationResult> {
        return Single.just(AuthenticationResult.undetermined)
    }

    var oauth: URL?

    var movies: MoyaProvider<Movies> = MoyaProviderMock<Movies>(stubClosure: MoyaProvider.immediatelyStub)
    var genres: MoyaProvider<Genres> = MoyaProviderMock<Genres>(stubClosure: MoyaProvider.immediatelyStub)
    var search: MoyaProvider<Search> = MoyaProviderMock<Search>(stubClosure: MoyaProvider.immediatelyStub)
    var shows: MoyaProvider<Shows> = MoyaProviderMock<Shows>(stubClosure: MoyaProvider.immediatelyStub)
    var authentication: MoyaProvider<Authentication> = MoyaProviderMock<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
    var sync: MoyaProvider<Sync> = MoyaProviderMock<Sync>(stubClosure: MoyaProvider.immediatelyStub)
    var episodes: MoyaProvider<Episodes> = MoyaProviderMock<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
    var users: MoyaProvider<Users> = MoyaProviderMock<Users>(stubClosure: MoyaProvider.delayedStub(100))

    init(oauthURL: URL? = nil) {
        oauth = oauthURL
    }
}
