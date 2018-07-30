import RxSwift

public final class DefaultSchedulers: Schedulers {
    public var networkScheduler: ImmediateSchedulerType
    public var networkQueue: DispatchQueue
    public var dataSourceScheduler: ImmediateSchedulerType
    public var dataSourceQueue: DispatchQueue
    public var ioScheduler: ImmediateSchedulerType
    public var ioQueue: DispatchQueue
    public var mainScheduler: ImmediateSchedulerType
    public var mainQueue: DispatchQueue

    public init() {
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
