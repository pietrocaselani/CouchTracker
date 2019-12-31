@testable import TraktSwift
import Moya

final class SyncTestableTrakt<Target: TraktType>: Trakt {
  private let endpointClosure: MoyaProvider<Target>.EndpointClosure

  init(builder: TraktBuilder, endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure) {
    self.endpointClosure = endpointClosure
    super.init(builder: builder)
  }

  override func createProvider<T: TraktType>(forTarget target: T.Type) -> MoyaProvider<T> {
    let provider = super.createProvider(forTarget: target)

    let fix = endpointClosure as! (T) -> Endpoint

    return MoyaProvider<T>(endpointClosure: fix,
                        requestClosure: provider.requestClosure,
                        stubClosure: MoyaProvider.immediatelyStub,
                        plugins: provider.plugins)
  }
}
