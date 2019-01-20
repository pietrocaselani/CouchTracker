import RxSwift

extension Observable where Element == WatchedShowEntity {
  func notifySyncState(_ syncStateOutput: SyncStateOutput) -> Observable<WatchedShowEntity> {
    return `do`(onError: { error in
      print(error.localizedDescription)
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    }, onCompleted: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    }, onSubscribe: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .syncing))
    })
  }
}
