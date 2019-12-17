import Moya
@testable import TVDBSwift

final class TVDBTestable: TVDB {
  override func createProvider<T>(forTarget target: T.Type) -> MoyaProvider<T> where T: TVDBType {
    let provider = super.createProvider(forTarget: target)

    return MoyaProvider(endpointClosure: provider.endpointClosure,
                        requestClosure: provider.requestClosure,
                        stubClosure: MoyaProvider.immediatelyStub,
                        callbackQueue: nil,
                        session: provider.session,
                        plugins: provider.plugins,
                        trackInflights: provider.trackInflights)
  }
}
