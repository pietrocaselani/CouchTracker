import CouchTrackerCore

extension WatchedShowEntity {
  static func mockEndedAndCompleted() -> WatchedShowEntity {
    return TraktEntitiesMock.endedAndCompletedShow()
  }
}
