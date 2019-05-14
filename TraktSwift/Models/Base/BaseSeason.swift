public final class BaseSeason: Codable, Hashable {
  public let number: Int
  public let episodes: [BaseEpisode]
  public let aired: Int?
  public let completed: Int?

  private enum CodingKeys: String, CodingKey {
    case number, episodes, aired, completed
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    number = try container.decode(Int.self, forKey: .number)
    episodes = try container.decode([BaseEpisode].self, forKey: .episodes)
    aired = try container.decodeIfPresent(Int.self, forKey: .aired)
    completed = try container.decodeIfPresent(Int.self, forKey: .completed)
  }

  public var hashValue: Int {
    var hash = number.hashValue

    if let airedHash = aired?.hashValue {
      hash = hash ^ airedHash
    }

    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }

    episodes.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: BaseSeason, rhs: BaseSeason) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
