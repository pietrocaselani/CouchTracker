@testable import CouchTrackerCore
import RxSwift
import RxTest

final class TestSchedulers: Schedulers {
  var dataSourceScheduler: ImmediateSchedulerType
  var dataSourceQueue: DispatchQueue
  var networkQueue: DispatchQueue
  var networkScheduler: SchedulerType
  var ioQueue: DispatchQueue
  var ioScheduler: SchedulerType
  var mainScheduler: SchedulerType
  var mainQueue: DispatchQueue
  let testScheduler: TestScheduler

  convenience init(initialClock: TestTime = 0) {
    self.init(mainScheduler: MainScheduler.instance,
              scheduler: TestScheduler(initialClock: initialClock))
  }

  init(mainScheduler: SchedulerType, scheduler: TestScheduler) {
    testScheduler = scheduler
    networkQueue = DispatchQueue.main
    networkScheduler = scheduler
    dataSourceQueue = DispatchQueue.main
    dataSourceScheduler = scheduler
    ioQueue = DispatchQueue.main
    ioScheduler = scheduler
    mainQueue = DispatchQueue.main
    self.mainScheduler = mainScheduler
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
