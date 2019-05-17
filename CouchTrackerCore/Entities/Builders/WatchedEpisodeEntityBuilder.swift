import Foundation
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
}
