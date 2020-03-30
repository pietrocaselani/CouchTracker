public struct SyncState: Hashable {
  public static let initial = SyncState(watchedShowsSyncState: .notSyncing)

  public let watchedShowsSyncState: WatchedShowsSyncState

  public var isSyncing: Bool {
    watchedShowsSyncState == .syncing
  }
}

public enum WatchedShowsSyncState: Hashable {
  case notSyncing
  case syncing
}
