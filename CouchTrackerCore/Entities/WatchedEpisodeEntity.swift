import TraktSwift

public struct WatchedEpisodeEntity: Hashable, Codable {
  public let episode: EpisodeEntity
  public let lastWatched: Date?

  public init(episode: EpisodeEntity, lastWatched: Date?) {
    self.episode = episode
    self.lastWatched = lastWatched
  }

  func asImageInput() -> EpisodeImageInput {
    return episode
  }
}
