import RxSwift

final class DispatchQueueScheduer: ImmediateSchedulerType {
  private let queue: DispatchQueue

  init(queue: DispatchQueue) {
    self.queue = queue
  }

  func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
    var actionDisposable: Disposable?

    let disposable = Disposables.create {
      actionDisposable?.dispose()
    }

    autoreleasepool {
      actionDisposable = queue.sync { return action(state) }
    }

    return disposable
  }
}
