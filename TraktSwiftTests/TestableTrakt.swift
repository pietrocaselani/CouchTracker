import Moya
@testable import TraktSwift

final class TestableTrakt: Trakt {
  override func createProvider<T>(forTarget target: T.Type) -> MoyaProvider<T> where T: TraktType {
    let provider = super.createProvider(forTarget: target)

    return MoyaProvider(endpointClosure: provider.endpointClosure,
                        requestClosure: provider.requestClosure,
                        stubClosure: MoyaProvider.immediatelyStub,
                        plugins: provider.plugins)
  }
}
