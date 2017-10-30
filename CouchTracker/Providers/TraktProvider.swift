import Moya
import RxSwift
import TraktSwift

protocol TraktProvider: class {
  var movies: RxMoyaProvider<Movies> { get }
  var genres: RxMoyaProvider<Genres> { get }
  var search: RxMoyaProvider<Search> { get }
  var shows: RxMoyaProvider<Shows> { get }
  var users: RxMoyaProvider<Users> { get }
  var authentication: RxMoyaProvider<Authentication> { get }
  var episodes: RxMoyaProvider<Episodes> { get }
  var sync: RxMoyaProvider<Sync> { get }
  var oauth: URL? { get }
  var isAuthenticated: Bool { get }

  func finishesAuthentication(with request: URLRequest) -> Observable<AuthenticationResult>
}
