import Foundation

public class StandardMediaEntity: Codable, Hashable {
  public let title: String?
  public let overview: String?
  public let rating: Double?
  public let votes: Int?
  public let updatedAt: Date?
  public let translations: [String]?

  private enum CodingKeys: String, CodingKey {
    case title
    case overview
    case rating
    case votes
    case updatedAt = "updated_at"
    case translations = "available_translations"
  }

  public init(title: String?, overview: String?, rating: Double?,
              votes: Int?, updatedAt: Date?, translations: [String]?) {
    self.title = title
    self.overview = overview
    self.rating = rating
    self.votes = votes
    self.updatedAt = updatedAt
    self.translations = translations
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    title = try container.decodeIfPresent(String.self, forKey: .title)
    overview = try container.decodeIfPresent(String.self, forKey: .overview)
    rating = try container.decodeIfPresent(Double.self, forKey: .rating)
    votes = try container.decodeIfPresent(Int.self, forKey: .votes)
    translations = try container.decodeIfPresent([String].self, forKey: .translations)

    let updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    self.updatedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(updatedAt)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(title)
    hasher.combine(overview)
    hasher.combine(rating)
    hasher.combine(votes)
    hasher.combine(updatedAt)
    hasher.combine(translations)
  }

  public static func == (lhs: StandardMediaEntity, rhs: StandardMediaEntity) -> Bool {
    lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.rating == rhs.rating &&
      lhs.votes == rhs.votes &&
      lhs.updatedAt == rhs.updatedAt &&
      lhs.translations == rhs.translations
  }
}
