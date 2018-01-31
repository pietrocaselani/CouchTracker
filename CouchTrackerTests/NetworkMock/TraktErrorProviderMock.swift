import TraktSwift
import RxSwift
import Moya

final class TraktErrorProviderMock: TraktProvider {
	func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
		return Single.just(AuthenticationResult.undetermined)
	}

	var oauth: URL?

	var movies: MoyaProvider<Movies> = MoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
	var genres: MoyaProvider<Genres> = MoyaProvider<Genres>(stubClosure: MoyaProvider.immediatelyStub)
	var search: MoyaProvider<Search> = MoyaProvider<Search>(stubClosure: MoyaProvider.immediatelyStub)
	var shows: MoyaProvider<Shows> = MoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
	var authentication: MoyaProvider<Authentication> = MoyaProvider<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
	var sync: MoyaProvider<Sync> = MoyaProvider<Sync>(stubClosure: MoyaProvider.immediatelyStub)
	var episodes: MoyaProvider<Episodes> = MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)

	var users: MoyaProvider<Users> = MoyaProvider<Users>(stubClosure: MoyaProvider.delayedStub(100))

	init(oauthURL: URL? = nil) {
		self.oauth = oauthURL
	}
}
