import RxSwift
import RealmSwift

#if DEBUG
public var Current = RealmEnvironment.live
#else
public let Current = RealmEnvironment.live
#endif

var realmProvider: RealmProvider = { badRealmProvider! }() // swiftlint:disable:this force_unwrapping
var scheduler: ImmediateSchedulerType = { badScheduler! }() // swiftlint:disable:this force_unwrapping

private var badRealmProvider: RealmProvider?
private var badScheduler: ImmediateSchedulerType?

public func setupPersistenceModule(realmProvider: RealmProvider, scheduler: ImmediateSchedulerType) {
  badRealmProvider = realmProvider
  badScheduler = scheduler
}
