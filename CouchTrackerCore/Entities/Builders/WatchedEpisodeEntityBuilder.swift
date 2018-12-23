import TraktSwift

public struct WatchedEpisodeEntityBuilder: Hashable {
  public let showIds: ShowIds
  public let episode: Episode
  public var lastWatched: Date?

  public init(showIds: ShowIds, episode: Episode, lastWatched: Date? = nil) {
    self.showIds = showIds
    self.episode = episode
    self.lastWatched = lastWatched
  }

  public func set(lastWatched: Date?) -> WatchedEpisodeEntityBuilder {
    return WatchedEpisodeEntityBuilder(showIds: showIds, episode: episode, lastWatched: lastWatched)
  }

  public func createEntity() -> WatchedEpisodeEntity {
    let episodeEntity = EpisodeEntityMapper.entity(for: episode, showIds: showIds)
    return WatchedEpisodeEntity(episode: episodeEntity, lastWatched: lastWatched)
  }

  public var hashValue: Int {
    var hash = showIds.hashValue ^ episode.hashValue
    lastWatched.run { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: WatchedEpisodeEntityBuilder, rhs: WatchedEpisodeEntityBuilder) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
