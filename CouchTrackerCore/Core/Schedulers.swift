import RxSwift

public protocol Schedulers: class {
    var networkScheduler: ImmediateSchedulerType { get }
    var networkQueue: DispatchQueue { get }
    var dataSourceScheduler: ImmediateSchedulerType { get }
    var dataSourceQueue: DispatchQueue { get }
    var ioScheduler: ImmediateSchedulerType { get }
    var ioQueue: DispatchQueue { get }
    var mainScheduler: ImmediateSchedulerType { get }
    var mainQueue: DispatchQueue { get }
}
