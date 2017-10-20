import Moya
import TVDBSwift

protocol TVDBProvider: class {
  var episodes: RxMoyaProvider<Episodes> { get }
}
