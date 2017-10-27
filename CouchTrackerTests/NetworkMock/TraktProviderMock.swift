import Moya
import Trakt
import RxSwift

let traktProviderMock = TraktProviderMock()

final class TraktProviderMock: TraktProvider {
  private let error: Swift.Error?

  func finishesAuthentication(with request: URLRequest) -> Observable<AuthenticationResult> {
    guard let error = error else {
      let result = oauth != nil ? AuthenticationResult.authenticated : AuthenticationResult.undetermined
      return Observable.just(result)
    }

    return Observable.error(error)
  }

  var oauth: URL?

  var movies: RxMoyaProvider<Movies> {
    return RxMoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var genres: RxMoyaProvider<Genres> {
    return RxMoyaProvider<Genres>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var search: RxMoyaProvider<Search> {
    return RxMoyaProvider<Search>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: RxMoyaProvider<Shows> {
    return RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var users: RxMoyaProvider<Users> {
    return RxMoyaProvider<Users>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var authentication: RxMoyaProvider<Authentication> {
    return RxMoyaProvider<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var sync: RxMoyaProvider<Sync> {
    return RxMoyaProvider<Sync>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var episodes: RxMoyaProvider<Episodes> {
    return RxMoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var isAuthenticated: Bool {
    return oauth != nil
  }

  init(oauthURL: URL? = nil, error: Swift.Error? = nil) {
    self.oauth = oauthURL
    self.error = error
  }
}
