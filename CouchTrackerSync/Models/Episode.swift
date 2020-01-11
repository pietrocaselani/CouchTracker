public struct Episode: Hashable, Codable {
  public let ids: EpisodeIds
  public let showIds: ShowIds
  public let title: String?
  public let overview: String?
  public let number: Int
  public let season: Int
  public let firstAired: Date?
  public let absoluteNumber: Int?
  public let runtime: Int?
  public let rating: Double?
  public let votes: Int?
  public let lastWatched: Date?

  public init(ids: EpisodeIds, showIds: ShowIds, title: String?, overview: String?,
              number: Int, season: Int, firstAired: Date?, absoluteNumber: Int?,
              runtime: Int?, rating: Double?, votes: Int?, lastWatched: Date?) {
    self.ids = ids
    self.showIds = showIds
    self.title = title
    self.overview = overview
    self.number = number
    self.season = season
    self.firstAired = firstAired
    self.absoluteNumber = absoluteNumber
    self.runtime = runtime
    self.rating = rating
    self.votes = votes
    self.lastWatched = lastWatched
  }
}
