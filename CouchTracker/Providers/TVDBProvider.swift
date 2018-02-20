import Moya
import TVDBSwift

protocol TVDBProvider: class {
	var episodes: MoyaProvider<Episodes> { get }
}
