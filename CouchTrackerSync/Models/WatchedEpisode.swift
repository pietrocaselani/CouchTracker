public struct WatchedEpisode: Hashable, Codable {
  public let episode: Episode
  public let lastWatched: Date?

  public init(episode: Episode, lastWatched: Date?) {
    self.episode = episode
    self.lastWatched = lastWatched
  }
}
