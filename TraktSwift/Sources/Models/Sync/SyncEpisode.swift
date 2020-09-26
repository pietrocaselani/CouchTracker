import Foundation

public struct SyncEpisode: Codable {
  public let ids: EpisodeIds
  public let season, number: Int?
  public let watchedAt, collectedAt, ratedAt: Date?
  public let rating: Rating?

  private enum CodingKeys: String, CodingKey {
    case ids, season, rating, number
    case watchedAt = "watched_at"
    case collectedAt = "collected_at"
    case ratedAt = "rated_at"
  }

  public init(ids: EpisodeIds, season: Int? = nil, number: Int? = nil, watchedAt: Date? = nil,
              collectedAt: Date? = nil, ratedAt: Date? = nil, rating: Rating? = nil) {
    self.ids = ids
    self.watchedAt = watchedAt
    self.season = season
    self.number = number
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    ids = try container.decode(EpisodeIds.self, forKey: .ids)
    season = try container.decodeIfPresent(Int.self, forKey: .season)
    number = try container.decodeIfPresent(Int.self, forKey: .number)
    rating = try container.decodeIfPresent(Rating.self, forKey: .rating)

    let watchedAt = try container.decodeIfPresent(String.self, forKey: .watchedAt)
    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    let ratedAt = try container.decodeIfPresent(String.self, forKey: .ratedAt)

    self.watchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(watchedAt)
    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)
    self.ratedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(ratedAt)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(ids, forKey: .ids)
    try container.encodeIfPresent(season, forKey: .season)
    try container.encodeIfPresent(number, forKey: .number)
    try container.encodeIfPresent(rating, forKey: .rating)

    let watchedAt = TraktDateTransformer.dateTimeTransformer.transformToJSON(self.watchedAt)
    let collectedAt = TraktDateTransformer.dateTimeTransformer.transformToJSON(self.collectedAt)
    let ratedAt = TraktDateTransformer.dateTimeTransformer.transformToJSON(self.ratedAt)

    try container.encodeIfPresent(watchedAt, forKey: .watchedAt)
    try container.encodeIfPresent(collectedAt, forKey: .collectedAt)
    try container.encodeIfPresent(ratedAt, forKey: .ratedAt)
  }
}
