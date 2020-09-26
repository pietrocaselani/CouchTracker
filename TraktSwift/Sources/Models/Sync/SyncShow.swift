import Foundation

public struct SyncShow: Codable {
  public let ids: ShowIds
  public let seasons: [SyncSeason]?
  public let collectedAt, watchedAt, ratedAt: Date?
  public let rating: Rating?

  private enum CodingKeys: String, CodingKey {
    case ids, seasons, rating
    case collectedAt = "collected_at"
    case watchedAt = "watched_at"
    case ratedAt = "rated_at"
  }

  public init(ids: ShowIds, seasons: [SyncSeason]?, collectedAt: Date?,
              watchedAt: Date?, ratedAt: Date?, rating: Rating?) {
    self.ids = ids
    self.seasons = seasons
    self.collectedAt = collectedAt
    self.watchedAt = watchedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    ids = try container.decode(ShowIds.self, forKey: .ids)
    seasons = try container.decodeIfPresent([SyncSeason].self, forKey: .seasons)
    rating = try container.decodeIfPresent(Rating.self, forKey: .rating)

    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    let watchedAt = try container.decodeIfPresent(String.self, forKey: .watchedAt)
    let ratedAt = try container.decodeIfPresent(String.self, forKey: .ratedAt)

    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)
    self.watchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(watchedAt)
    self.ratedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(ratedAt)
  }
}
