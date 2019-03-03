import CouchTrackerCore
import RxSwift

enum SyncStateMocks {
  final class SyncStateObservableMock: SyncStateObservable {
    func observe() -> Observable<SyncState> {
      return Observable.just(SyncState.initial)
    }
  }
}
