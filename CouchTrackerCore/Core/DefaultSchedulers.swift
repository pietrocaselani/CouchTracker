import RxSwift

public final class DefaultSchedulers: Schedulers {
	public var networkScheduler: ImmediateSchedulerType
	public var networkQueue: DispatchQueue
	public var dataSourceScheduler: ImmediateSchedulerType
	public var dataSourceQueue: DispatchQueue
	public var ioScheduler: ImmediateSchedulerType
	public var ioQueue: DispatchQueue

	public init() {
		self.networkQueue = DispatchQueue(label: "NetworkQueue", qos: .utility)
		self.dataSourceQueue = DispatchQueue(label: "RealmQueue", qos: .utility)
		self.ioQueue = DispatchQueue(label: "IOQueue", qos: .utility)

		self.networkScheduler = ConcurrentDispatchQueueScheduler(queue: networkQueue)
		self.dataSourceScheduler = ThreadWithRunLoopScheduler(name: "RealmScheduler")
		self.ioScheduler = ConcurrentDispatchQueueScheduler(queue: ioQueue)
	}
}
