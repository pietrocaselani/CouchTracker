import RxSwift

extension Observable where Element == WatchedShowEntity {
  func notifySyncState(_ syncStateOutput: SyncStateOutput) -> Observable<WatchedShowEntity> {
    return `do`(onError: { _ in
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    }, onCompleted: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    }, onSubscribe: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .syncing))
    })
  }
}

extension PrimitiveSequenceType where TraitType == SingleTrait, ElementType == [WatchedShowEntity] {
  func notifySyncState(_ syncStateOutput: SyncStateOutput) -> PrimitiveSequence<SingleTrait, [WatchedShowEntity]> {
    return `do`(onError: { _ in
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    }, onSubscribe: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .syncing))
    }, onDispose: {
      syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .notSyncing))
    })
  }
}
