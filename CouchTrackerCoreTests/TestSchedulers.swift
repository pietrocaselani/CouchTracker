import RxSwift
import RxTest
@testable import CouchTrackerCore

final class TestSchedulers: Schedulers {
	var dataSourceScheduler: ImmediateSchedulerType
	var dataSourceQueue: DispatchQueue
	var networkQueue: DispatchQueue
	var networkScheduler: ImmediateSchedulerType
	var ioQueue: DispatchQueue
	var ioScheduler: ImmediateSchedulerType
	var mainScheduler: ImmediateSchedulerType
	var mainQueue: DispatchQueue
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
		self.mainQueue = DispatchQueue.main
		self.mainScheduler = scheduler
	}

	func start() {
		testScheduler.start()
	}

	func start<E>(_ create: @escaping () -> Observable<E>) -> TestableObserver<E> {
		return testScheduler.start(create)
	}

	func createObserver<E>(_ type: E.Type) -> TestableObserver<E> {
		return testScheduler.createObserver(type)
	}
}
