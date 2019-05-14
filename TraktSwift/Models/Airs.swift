public final class Airs: Codable, Hashable {
  public let day: String?
  public let time: String?
  public let timezone: String

  private enum CodingKeys: String, CodingKey {
    case day, time, timezone
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    day = try container.decodeIfPresent(String.self, forKey: .day)
    time = try container.decodeIfPresent(String.self, forKey: .time)
    timezone = try container.decode(String.self, forKey: .timezone)
  }

  public var hashValue: Int {
    var hash = timezone.hashValue

    if let dayHash = day?.hashValue {
      hash ^= dayHash
    }

    if let timeHash = time?.hashValue {
      hash ^= timeHash
    }

    return hash
  }

  public static func == (lhs: Airs, rhs: Airs) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
