public struct WatchedShow: Hashable, Codable {
  public let show: Show
  public let aired: Int?
  public let completed: Int?
  public let nextEpisode: WatchedEpisode?
  public let lastEpisode: WatchedEpisode?
  public let lastWatched: Date?

  public init(show: Show, aired: Int?, completed: Int?,
              nextEpisode: WatchedEpisode?, lastEpisode: WatchedEpisode?, lastWatched: Date?) {
    self.show = show
    self.aired = aired
    self.completed = completed
    self.nextEpisode = nextEpisode
    self.lastEpisode = lastEpisode
    self.lastWatched = lastWatched
  }
}
