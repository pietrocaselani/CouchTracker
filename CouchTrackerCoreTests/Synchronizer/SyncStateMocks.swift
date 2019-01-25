import CouchTrackerCore
import RxSwift

enum SyncStateMocks {
  final class SyncStateOutputMock: SyncStateOutput {
    var statesNotified = [SyncState]()
    var newSyncStateInvokedCount = 0

    func newSyncState(state: SyncState) {
      newSyncStateInvokedCount += 1
      statesNotified.append(state)
    }
  }

  final class SyncStateObservableMock: SyncStateObservable {
    func observe() -> Observable<SyncState> {
      return Observable.just(SyncState.initial)
    }
  }
}
