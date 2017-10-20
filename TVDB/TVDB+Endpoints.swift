import Moya
import RxSwift

extension TVDB {
  public var authentication: RxMoyaProvider<Authentication> {
    return createProvider(forTarget: Authentication.self)
  }

  public var episodes: RxMoyaProvider<Episodes> {
    return createProvider(forTarget: Episodes.self)
  }
}
