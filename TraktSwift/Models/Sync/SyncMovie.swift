import Foundation

public struct SyncMovie: Codable {
  public let ids: MovieIds
  public let watchedAt, collectedAt, ratedAt: Date?
  public let rating: Rating?

  private enum CodingKeys: String, CodingKey {
    case ids, rating
    case watchedAt = "watched_at"
    case collectedAt = "collected_at"
    case ratedAt = "rated_at"
  }

  public init(ids: MovieIds, watchedAt: Date? = nil, collectedAt: Date? = nil,
              ratedAt: Date? = nil, rating: Rating? = nil) {
    self.ids = ids
    self.watchedAt = watchedAt
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    ids = try container.decode(MovieIds.self, forKey: .ids)
    rating = try container.decodeIfPresent(Rating.self, forKey: .rating)

    let watchedAt = try container.decodeIfPresent(String.self, forKey: .watchedAt)
    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    let ratedAt = try container.decodeIfPresent(String.self, forKey: .ratedAt)

    self.watchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(watchedAt)
    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)
    self.ratedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(ratedAt)
  }
}
