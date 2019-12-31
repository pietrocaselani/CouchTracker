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

private final class TestableClass: NSObject {}
private let bundle = Bundle(for: TestableClass.self)
func contentsOf(file named: String) -> Data {
  return bundle.url(forResource: named, withExtension: "json").map { try! Data(contentsOf: $0) }!
}

func makeTestableTrakt<Target: TraktType>(_ sampleResponse: EndpointSampleResponse) -> SyncTestableTrakt<Target> {
    let builder = TraktBuilder {
      $0.clientId = "clientIdMock"
      $0.clientSecret = "clientSecretMock"
      $0.redirectURL = "https://google.com"
      $0.userDefaults = UserDefaults(suiteName: "SyncTestableTraktUserDefaults")!
    }

    return SyncTestableTrakt(builder: builder, endpointClosure: { target in
      Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: { sampleResponse },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
      )
    })
}
