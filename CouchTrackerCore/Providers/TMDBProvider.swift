import Moya
import TMDBSwift

public protocol TMDBProvider: AnyObject {
  var movies: MoyaProvider<Movies> { get }
  var shows: MoyaProvider<Shows> { get }
  var configuration: MoyaProvider<ConfigurationService> { get }
  var episodes: MoyaProvider<Episodes> { get }
}
