enum SyncResult {
  case success(show: WatchedShowEntity)
  case fail(error: Error)
}
