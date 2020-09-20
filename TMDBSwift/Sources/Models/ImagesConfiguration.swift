public final class ImagesConfiguration: Hashable, Codable {
  public let secureBaseURL: String
  public let backdropSizes: [String]
  public let posterSizes: [String]
  public let stillSizes: [String]

  private enum CodingKeys: String, CodingKey {
    case secureBaseURL = "secure_base_url"
    case backdropSizes = "backdrop_sizes"
    case posterSizes = "poster_sizes"
    case stillSizes = "still_sizes"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    secureBaseURL = try container.decode(String.self, forKey: .secureBaseURL)
    backdropSizes = try container.decode([String].self, forKey: .backdropSizes)
    posterSizes = try container.decode([String].self, forKey: .posterSizes)
    stillSizes = try container.decode([String].self, forKey: .backdropSizes)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(secureBaseURL)
    hasher.combine(backdropSizes)
    hasher.combine(posterSizes)
    hasher.combine(stillSizes)
  }

  public static func == (lhs: ImagesConfiguration, rhs: ImagesConfiguration) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
