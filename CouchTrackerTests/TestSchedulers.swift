import RxSwift
import RxTest

final class TestSchedulers: Schedulers {
	var dataSourceScheduler: ImmediateSchedulerType
	var dataSourceQueue: DispatchQueue
	var networkQueue: DispatchQueue
	var networkScheduler: ImmediateSchedulerType
	var ioQueue: DispatchQueue
	var ioScheduler: ImmediateSchedulerType
	let testScheduler: TestScheduler

	init(initialClock: TestTime = 0) {
		let scheduler = TestScheduler(initialClock: 0)
		self.testScheduler = scheduler
		self.networkQueue = DispatchQueue.main
		self.networkScheduler = scheduler
		self.dataSourceQueue = DispatchQueue.main
		self.dataSourceScheduler = scheduler
		self.ioQueue = DispatchQueue.main
		self.ioScheduler = scheduler
	}

	func start() {
		testScheduler.start()
	}

	func createObserver<E>(_ type: E.Type) -> TestableObserver<E> {
		return testScheduler.createObserver(type)
	}
}
