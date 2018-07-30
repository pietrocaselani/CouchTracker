import RxSwift

final class ThreadWithRunLoopScheduler: ImmediateSchedulerType {
    private let thread: ThreadWithRunLoop

    init(name: String) {
        thread = ThreadWithRunLoop()
        thread.name = name
        thread.start()
    }

    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let disposable = SingleAssignmentDisposable()

        thread.runLoop.perform {
            disposable.setDisposable(action(state))
        }

        return disposable
    }
}
