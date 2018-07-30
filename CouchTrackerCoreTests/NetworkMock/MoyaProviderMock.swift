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
}
