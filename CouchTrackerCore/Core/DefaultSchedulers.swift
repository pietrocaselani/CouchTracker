import RxSwift

public final class DefaultSchedulers: Schedulers {
  public static let instance = DefaultSchedulers()
  public var networkScheduler: SchedulerType
  public var networkQueue: DispatchQueue
  public var dataSourceScheduler: ImmediateSchedulerType
  public var dataSourceQueue: DispatchQueue
  public var ioScheduler: SchedulerType
  public var ioQueue: DispatchQueue
  public var mainScheduler: SchedulerType
  public var mainQueue: DispatchQueue

  private init() {
    networkQueue = DispatchQueue(label: "NetworkQueue", qos: .utility)
    dataSourceQueue = DispatchQueue(label: "RealmQueue", qos: .utility)
    ioQueue = DispatchQueue(label: "IOQueue", qos: .utility)
    mainQueue = DispatchQueue.main

    networkScheduler = ConcurrentDispatchQueueScheduler(queue: networkQueue)
    dataSourceScheduler = ThreadWithRunLoopScheduler(name: "RealmScheduler")
    ioScheduler = ConcurrentDispatchQueueScheduler(queue: ioQueue)
    mainScheduler = MainScheduler.instance
  }
}
