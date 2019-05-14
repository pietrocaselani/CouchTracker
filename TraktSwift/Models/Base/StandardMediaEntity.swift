import Foundation

public class StandardMediaEntity: Codable, Hashable {
  public var title: String?
  public var overview: String?
  public var rating: Double?
  public var votes: Int?
  public var updatedAt: Date?
  public var translations: [String]?

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

  public var hashValue: Int {
    var hash = 0

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }

    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }

    if let updatedAtHash = updatedAt?.hashValue {
      hash = hash ^ updatedAtHash
    }

    translations?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: StandardMediaEntity, rhs: StandardMediaEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
