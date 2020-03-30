import Foundation
import TraktSwift

public struct EpisodeEntity: Hashable, Codable, EpisodeImageInput {
  public let ids: EpisodeIds
  public let showIds: ShowIds
  public let title: String
  public let overview: String?
  public let number: Int
  public let season: Int
  public let firstAired: Date?
  public let absoluteNumber: Int?

  public init(ids: EpisodeIds, showIds: ShowIds, title: String,
              overview: String?, number: Int, season: Int, firstAired: Date?, absoluteNumber: Int?) {
    self.ids = ids
    self.showIds = showIds
    self.title = title
    self.overview = overview
    self.number = number
    self.season = season
    self.firstAired = firstAired
    self.absoluteNumber = absoluteNumber
  }

  public var tvdb: Int? {
    ids.tvdb
  }

  public var tmdb: Int? {
    showIds.tmdb
  }
}
