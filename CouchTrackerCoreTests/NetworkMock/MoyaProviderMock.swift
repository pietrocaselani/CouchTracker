import Moya

final class MoyaProviderMock<Target: TargetType>: MoyaProvider<Target> {
  var requestInvoked = false
  var requestInvokedCount = 0
  var targetInvoked: Target?

  override func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable {
    requestInvoked = true
    requestInvokedCount += 1
    targetInvoked = target
    return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
  }

  static func createProvider<T: TargetType>(error: Error? = nil, target _: T.Type) -> MoyaProvider<T> {
    guard error != nil else {
      return MoyaProviderMock<T>(stubClosure: MoyaProvider.immediatelyStub)
    }

    return MoyaProviderMock<T>(endpointClosure: { endpointTarget in
      MoyaProviderMock.errorEndpointsClosure(target: endpointTarget)
    }, stubClosure: MoyaProvider.immediatelyStub)
  }

  static func errorEndpointsClosure<T: TargetType>(target: T) -> Endpoint {
    let sampleResponseClosure = { () -> EndpointSampleResponse in
      .networkResponse(500, Data())
    }

    let url = target.baseURL.appendingPathComponent(target.path).absoluteString

    return Endpoint(url: url,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
  }
}
