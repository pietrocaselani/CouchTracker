import CouchTrackerCore

extension WatchedShowEntity {
  static func mockEndedAndCompleted(decoder: JSONDecoder = .init()) -> WatchedShowEntity {
    let data = Fixtures.WatchedShowEntity.jsonDataFor(file: "ended_completed")
    return try! decoder.decode(WatchedShowEntity.self, from: data)
  }
}
