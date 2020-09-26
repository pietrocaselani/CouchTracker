import Foundation

public struct BaseEpisode: Codable, Hashable {
  public let number: Int
  public let collectedAt: Date?
  public let plays: Int?
  public let lastWatchedAt: Date?
  public let completed: Bool?

  private enum CodingKeys: String, CodingKey {
    case number
    case collectedAt = "collected_at"
    case lastWatchedAt = "last_watched_at"
    case plays
    case completed
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    number = try container.decode(Int.self, forKey: .number)
    plays = try container.decodeIfPresent(Int.self, forKey: .plays)
    completed = try container.decodeIfPresent(Bool.self, forKey: .completed)

    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)

    let lastWatchedAt = try container.decodeIfPresent(String.self, forKey: .lastWatchedAt)
    self.lastWatchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(lastWatchedAt)
  }
}
