import Moya
import TVDBSwift

public protocol TVDBProvider: AnyObject {
  var episodes: MoyaProvider<Episodes> { get }
}
