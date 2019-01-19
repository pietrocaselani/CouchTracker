import CouchTrackerCore

enum SyncStateMocks {
  final class SyncStateOutputMock: SyncStateOutput {
    var statesNotified = [SyncState]()
    var newSyncStateInvokedCount = 0

    func newSyncState(state: SyncState) {
      newSyncStateInvokedCount += 1
      statesNotified.append(state)
    }
  }
}
