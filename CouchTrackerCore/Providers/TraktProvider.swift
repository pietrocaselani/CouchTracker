import Moya
import RxSwift
import TraktSwift

public protocol TraktProvider: class {
    var movies: MoyaProvider<Movies> { get }
    var genres: MoyaProvider<Genres> { get }
    var search: MoyaProvider<Search> { get }
    var shows: MoyaProvider<Shows> { get }
    var users: MoyaProvider<Users> { get }
    var authentication: MoyaProvider<Authentication> { get }
    var episodes: MoyaProvider<Episodes> { get }
    var sync: MoyaProvider<Sync> { get }
    var oauth: URL? { get }

    func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult>
}
