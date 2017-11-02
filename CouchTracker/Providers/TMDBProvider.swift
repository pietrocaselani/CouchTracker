import Moya
import TMDBSwift

protocol TMDBProvider: class {
  var movies: MoyaProvider<Movies> { get }
  var shows: MoyaProvider<Shows> { get }
  var configuration: MoyaProvider<ConfigurationService> { get }
  var episodes: MoyaProvider<Episodes> { get }
}
