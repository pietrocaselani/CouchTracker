import Moya

final class MoyaProviderMock<Target: TargetType>: MoyaProvider<Target> {
  var requestInvoked = false

  override func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable {
    requestInvoked = true
    return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
  }
}
