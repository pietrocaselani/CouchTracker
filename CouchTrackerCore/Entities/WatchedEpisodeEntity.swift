import TraktSwift

public struct WatchedEpisodeEntity: Hashable {
  public let episode: EpisodeEntity
  public let lastWatched: Date?

  public init(episode: EpisodeEntity, lastWatched: Date?) {
    self.episode = episode
    self.lastWatched = lastWatched
  }

  func asImageInput() -> EpisodeImageInput {
    return episode
  }

  public var hashValue: Int {
    var hash = episode.hashValue
    lastWatched.run { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: WatchedEpisodeEntity, rhs: WatchedEpisodeEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
