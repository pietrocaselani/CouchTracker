import RxSwift

public struct SyncSchedulers {
  public static let live: SyncSchedulers = {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 5
    let scheduler = OperationQueueScheduler(operationQueue: operationQueue)
    return SyncSchedulers(syncScheduler: scheduler)
  }()

  public let syncScheduler: ImmediateSchedulerType
}
