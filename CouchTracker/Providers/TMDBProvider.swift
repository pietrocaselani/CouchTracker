import Moya
import TMDBSwift

protocol TMDBProvider: class {
  var movies: RxMoyaProvider<Movies> { get }
  var shows: RxMoyaProvider<Shows> { get }
  var configuration: RxMoyaProvider<ConfigurationService> { get }
  var episodes: RxMoyaProvider<Episodes> { get }
}
