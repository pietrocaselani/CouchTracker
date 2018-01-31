import RxSwift
import RxTest

final class TestSchedulers: Schedulers {
  var networkQueue: DispatchQueue
  var networkScheduler: ImmediateSchedulerType
  let testScheduler: TestScheduler

  init(initialClock: TestTime = 0) {
    let scheduler = TestScheduler(initialClock: 0)
    self.networkQueue = DispatchQueue.main
    self.networkScheduler = scheduler
    self.testScheduler = scheduler
  }

  func start() {
    testScheduler.start()
  }

  func createObserver<E>(_ type: E.Type) -> TestableObserver<E> {
    return testScheduler.createObserver(type)
  }
}
