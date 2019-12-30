import RxSwift

struct SyncState {}

enum SyncAction {}

func syncReducer(state: inout SyncState, action: SyncAction) -> [Observable<SyncAction>] {
    return []
}
