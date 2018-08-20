import TraktSwift

public final class WatchedEpisodeEntityBuilder: Hashable {
  public let showIds: ShowIds
  public let episode: Episode
  public var lastWatched: Date?

  public init(showIds: ShowIds, episode: Episode) {
    self.showIds = showIds
    self.episode = episode
  }

  @discardableResult
  public func set(lastWatched: Date?) -> WatchedEpisodeEntityBuilder {
    self.lastWatched = lastWatched
    return self
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
