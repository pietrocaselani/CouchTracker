public enum CouchTrackerError: Error {
  case selfDeinitialized
  case watchedShowSyncMergeError
  case custom(error: Error)
  case missingTraktOAuthURL
}
