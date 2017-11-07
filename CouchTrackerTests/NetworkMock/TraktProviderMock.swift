import Moya
import TraktSwift
import RxSwift

let traktProviderMock = TraktProviderMock()

final class TraktProviderMock: TraktProvider, TraktAuthenticationProvider {
  private let error: Swift.Error?

  func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
    guard let error = error else {
      let result = oauth != nil ? AuthenticationResult.authenticated : AuthenticationResult.undetermined
      return Single.just(result)
    }

    return Single.error(error)
  }

  var oauth: URL?

  var movies: MoyaProvider<Movies> {
    return MoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var genres: MoyaProvider<Genres> {
    return MoyaProvider<Genres>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var search: MoyaProvider<Search> {
    return MoyaProvider<Search>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: MoyaProvider<Shows> {
    return MoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var users: MoyaProvider<Users> {
    return MoyaProvider<Users>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var authentication: MoyaProvider<Authentication> {
    return MoyaProvider<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var sync: MoyaProvider<Sync> {
    return MoyaProvider<Sync>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var episodes: MoyaProvider<Episodes> {
    return MoyaProvider<Episodes>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var isAuthenticated: Bool {
    return oauth != nil
  }

  init(oauthURL: URL? = nil, error: Swift.Error? = nil) {
    self.oauth = oauthURL
    self.error = error
  }
}
