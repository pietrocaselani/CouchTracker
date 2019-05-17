import Foundation

public struct SyncSeason: Codable {
  public let number: Int
  public let watchedAt: Date
  public let episodes: [SyncEpisode]?
  public let collectedAt, ratedAt: Date?
  public let rating: Rating?

  private enum CodingKeys: String, CodingKey {
    case number, episodes, rating
    case watchedAt = "watched_at"
    case collectedAt = "collected_at"
    case ratedAt = "rated_at"
  }

  public init(number: Int, watchedAt: Date, episodes: [SyncEpisode]?,
              collectedAt: Date?, ratedAt: Date?, rating: Rating?) {
    self.number = number
    self.watchedAt = watchedAt
    self.episodes = episodes
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    number = try container.decode(Int.self, forKey: .number)
    episodes = try container.decodeIfPresent([SyncEpisode].self, forKey: .episodes)
    rating = try container.decodeIfPresent(Rating.self, forKey: .rating)

    let watchedAt = try container.decode(String.self, forKey: .watchedAt)
    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    let ratedAt = try container.decodeIfPresent(String.self, forKey: .ratedAt)

    guard let watchedDate = TraktDateTransformer.dateTimeTransformer.transformFromJSON(watchedAt) else {
      let message = "JSON key: watched_at - Value: \(watchedAt) - Error: Could not transform to date"
      throw TraktError.missingJSONValue(message: message)
    }

    self.watchedAt = watchedDate
    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)
    self.ratedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(ratedAt)
  }

  public func encode(to _: Encoder) throws {}
}
