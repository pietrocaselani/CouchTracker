import Moya
import TVDBSwift

public protocol TVDBProvider: class {
    var episodes: MoyaProvider<Episodes> { get }
}
