import RxSwift

public protocol Schedulers: class {
  var networkScheduler: SchedulerType { get }
  var networkQueue: DispatchQueue { get }
  var dataSourceScheduler: ImmediateSchedulerType { get }
  var dataSourceQueue: DispatchQueue { get }
  var ioScheduler: SchedulerType { get }
  var ioQueue: DispatchQueue { get }
  var mainScheduler: SchedulerType { get }
  var mainQueue: DispatchQueue { get }
}
