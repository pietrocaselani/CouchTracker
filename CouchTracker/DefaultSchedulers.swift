import RxSwift

final class DefaultSchedulers: Schedulers {
  var networkScheduler: ImmediateSchedulerType
  var networkQueue: DispatchQueue
  var dataSourceScheduler: ImmediateSchedulerType
  var dataSourceQueue: DispatchQueue
  var ioScheduler: ImmediateSchedulerType
  var ioQueue: DispatchQueue

  init() {
    self.networkQueue = DispatchQueue(label: "NetworkQueue", qos: .utility)
    self.dataSourceQueue = DispatchQueue(label: "RealmQueue", qos: .utility)
    self.ioQueue = DispatchQueue(label: "IOQueue", qos: .utility)

    self.networkScheduler = ConcurrentDispatchQueueScheduler(queue: networkQueue)
    self.dataSourceScheduler = ThreadWithRunLoopScheduler(name: "RealmScheduler")
    self.ioScheduler = ConcurrentDispatchQueueScheduler(queue: ioQueue)
  }
}
