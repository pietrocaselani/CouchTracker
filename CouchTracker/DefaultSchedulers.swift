import RxSwift

final class DefaultSchedulers: Schedulers {
  var networkScheduler: ImmediateSchedulerType
  var networkQueue: DispatchQueue

  init() {
    self.networkQueue = DispatchQueue(label: "NetworkQueue", qos: .background)
    self.networkScheduler = ConcurrentDispatchQueueScheduler(queue: networkQueue)
  }
}
