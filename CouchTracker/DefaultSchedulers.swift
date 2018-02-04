import RxSwift

final class DefaultSchedulers: Schedulers {
  var networkScheduler: ImmediateSchedulerType
  var networkQueue: DispatchQueue
  var dataSourceScheduler: ImmediateSchedulerType
  var dataSourceQueue: DispatchQueue

  init() {
    self.networkQueue = DispatchQueue(label: "NetworkQueue", qos: .background)
    self.dataSourceQueue = DispatchQueue(label: "RealmQueue", qos: .background)

    self.networkScheduler = ConcurrentDispatchQueueScheduler(queue: networkQueue)
    self.dataSourceScheduler = ThreadWithRunLoopScheduler(name: "RealmScheduler")
  }
}
