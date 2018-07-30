@testable import CouchTrackerCore
import RxSwift
import RxTest

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

    init(initialClock _: TestTime = 0) {
        let scheduler = TestScheduler(initialClock: 0)
        testScheduler = scheduler
        networkQueue = DispatchQueue.main
        networkScheduler = scheduler
        dataSourceQueue = DispatchQueue.main
        dataSourceScheduler = scheduler
        ioQueue = DispatchQueue.main
        ioScheduler = scheduler
        mainQueue = DispatchQueue.main
        mainScheduler = scheduler
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
