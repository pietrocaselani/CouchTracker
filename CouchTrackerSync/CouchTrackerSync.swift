import RxSwift

enum SyncState {
  case notSyncing
  case started
}

struct SyncData {
  var state: SyncState
}

enum SyncAction {
  case start
}

func syncReducer(syncData: inout SyncData, action: SyncAction) -> [Observable<SyncAction>] {
  switch action {
  case .start:
    syncData.state = .started
  }

  return []
}
