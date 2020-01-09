public struct Show: Hashable, Codable {
  public let ids: ShowIds
  public let title: String?
  public let overview: String?
  public let network: String?
  public let genres: [Genre]
  public let status: Status?
  public let firstAired: Date?
  public let seasons: [WatchedSeason]
  public let aired: Int?
  public let nextEpisode: WatchedEpisode?
  public let watched: Watched

  public struct Watched: Hashable, Codable {
    public let completed: Int?
    public let lastEpisode: WatchedEpisode?

    public init(completed: Int?, lastEpisode: WatchedEpisode?) {
      self.completed = completed
      self.lastEpisode = lastEpisode
    }
  }

  public init(ids: ShowIds, title: String?, overview: String?, network: String?, genres: [Genre], status: Status?,
              firstAired: Date?, seasons: [WatchedSeason], aired: Int?, nextEpisode: WatchedEpisode?, watched: Watched) {
    self.ids = ids
    self.title = title
    self.overview = overview
    self.network = network
    self.genres = genres
    self.status = status
    self.firstAired = firstAired
    self.seasons = seasons
    self.aired = aired
    self.nextEpisode = nextEpisode
    self.watched = watched
  }
}
