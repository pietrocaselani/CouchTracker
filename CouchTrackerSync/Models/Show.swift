import TraktSwift

public struct Show: Hashable, Codable {
  public let ids: ShowIds
  public let title: String?
  public let overview: String?
  public let network: String?
  public let genres: [Genre]
  public let status: Status?
  public let firstAired: Date?
  public let seasons: [WatchedSeason]

  public init(ids: ShowIds, title: String?, overview: String?, network: String?,
              genres: [Genre], status: Status?, firstAired: Date?, seasons: [WatchedSeason]) {
    self.ids = ids
    self.title = title
    self.overview = overview
    self.network = network
    self.genres = genres
    self.status = status
    self.firstAired = firstAired
    self.seasons = seasons
  }
}
