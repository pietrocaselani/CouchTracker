import Foundation

public final class Show: StandardMediaEntity {
  public let year: Int?
  public let ids: ShowIds
  public let firstAired: Date?
  public let airs: Airs?
  public let runtime: Int?
  public let certification: String?
  public let network: String?
  public let country: String?
  public let trailer: String?
  public let homepage: String?
  public let status: Status?
  public let language: String?
  public let genres: [String]?

  private enum CodingKeys: String, CodingKey {
    case year, ids, airs, runtime, certification, network, country, trailer, homepage, status, language, genres
    case firstAired = "first_aired"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    year = try container.decodeIfPresent(Int.self, forKey: .year)
    ids = try container.decode(ShowIds.self, forKey: .ids)
    airs = try container.decodeIfPresent(Airs.self, forKey: .airs)
    runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
    certification = try container.decodeIfPresent(String.self, forKey: .certification)
    network = try container.decodeIfPresent(String.self, forKey: .network)
    country = try container.decodeIfPresent(String.self, forKey: .country)
    trailer = try container.decodeIfPresent(String.self, forKey: .trailer)
    homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
    status = try container.decodeIfPresent(String.self, forKey: .status).flatMap(Status.init(rawValue:))
    language = try container.decodeIfPresent(String.self, forKey: .language)
    genres = try container.decodeIfPresent([String].self, forKey: .genres)

    let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
    self.firstAired = TraktDateTransformer.dateTimeTransformer.transformFromJSON(firstAired)

    try super.init(from: decoder)
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(year)
    hasher.combine(ids)
    hasher.combine(firstAired)
    hasher.combine(airs)
    hasher.combine(runtime)
    hasher.combine(certification)
    hasher.combine(network)
    hasher.combine(country)
    hasher.combine(trailer)
    hasher.combine(homepage)
    hasher.combine(status)
    hasher.combine(language)
    hasher.combine(genres)
  }

  public static func == (lhs: Show, rhs: Show) -> Bool {
    let lhsMediaEntity = lhs as StandardMediaEntity
    let rhsMediaEntity = rhs as StandardMediaEntity

    return lhsMediaEntity == rhsMediaEntity &&
      lhs.year == rhs.year &&
      lhs.ids == rhs.ids &&
      lhs.firstAired == rhs.firstAired &&
      lhs.airs == rhs.airs &&
      lhs.runtime == rhs.runtime &&
      lhs.certification == rhs.certification &&
      lhs.network == rhs.network &&
      lhs.country == rhs.country &&
      lhs.trailer == rhs.trailer &&
      lhs.homepage == rhs.homepage &&
      lhs.status == rhs.status &&
      lhs.language == rhs.language &&
      lhs.genres == rhs.genres
  }
}
