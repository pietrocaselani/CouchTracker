@testable import TraktSwift
import Moya

public class TestableTrakt: Trakt {
  public override init(builder: TraktBuilder) {
    super.init(builder: builder)
  }

  public convenience init() {
    self.init(builder: TraktBuilder(buildClosure: {
      $0.clientId = "fakeClientId"
      $0.clientSecret = "fakeClientSecret"
    }))
  }

  override public func createProvider<T>(forTarget target: T.Type) -> MoyaProvider<T> where T: TraktType {
    let provider = super.createProvider(forTarget: target)

    return MoyaProvider(endpointClosure: provider.endpointClosure,
                        requestClosure: provider.requestClosure,
                        stubClosure: MoyaProvider.immediatelyStub,
                        plugins: provider.plugins)
  }
}
