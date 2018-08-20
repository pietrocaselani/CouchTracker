import Foundation
import TraktSwift

public struct EpisodeEntity: Hashable, EpisodeImageInput {
  public let ids: EpisodeIds
  public let showIds: ShowIds
  public let title: String
  public let overview: String?
  public let number: Int
  public let season: Int
  public let firstAired: Date?

  public var tvdb: Int? {
    return ids.tvdb
  }

  public var tmdb: Int? {
    return showIds.tmdb
  }

  public var hashValue: Int {
    var hash = ids.hashValue ^ title.hashValue ^ number.hashValue ^ season.hashValue
    firstAired.run { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: EpisodeEntity, rhs: EpisodeEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
