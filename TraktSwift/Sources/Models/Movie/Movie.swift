import Foundation

public final class Movie: StandardMediaEntity {
  public let year: Int?
  public let ids: MovieIds
  public let certification: String?
  public let tagline: String?
  public let released: Date?
  public let runtime: Int?
  public let trailer: String?
  public let homepage: String?
  public let language: String?
  public let genres: [String]?

  private enum CodingKeys: String, CodingKey {
    case year, ids, certification, tagline, released, runtime, trailer, homepage, language, genres
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    year = try container.decodeIfPresent(Int.self, forKey: .year)
    ids = try container.decode(MovieIds.self, forKey: .ids)
    certification = try container.decodeIfPresent(String.self, forKey: .certification)
    tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
    trailer = try container.decodeIfPresent(String.self, forKey: .trailer)
    homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
    language = try container.decodeIfPresent(String.self, forKey: .language)
    genres = try container.decodeIfPresent([String].self, forKey: .genres)

    let released = try container.decodeIfPresent(String.self, forKey: .released)
    self.released = TraktDateTransformer.dateTransformer.transformFromJSON(released)

    try super.init(from: decoder)
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(year)
    hasher.combine(ids)
    hasher.combine(certification)
    hasher.combine(tagline)
    hasher.combine(released)
    hasher.combine(runtime)
    hasher.combine(trailer)
    hasher.combine(homepage)
    hasher.combine(language)
    hasher.combine(genres)
  }

  public static func == (lhs: Movie, rhs: Movie) -> Bool {
    let lhsMediaEntity = lhs as StandardMediaEntity
    let rhsMediaEntity = rhs as StandardMediaEntity

    return lhsMediaEntity == rhsMediaEntity &&
      lhs.year == rhs.year &&
      lhs.ids == rhs.ids &&
      lhs.certification == rhs.certification &&
      lhs.tagline == rhs.tagline &&
      lhs.released == rhs.released &&
      lhs.runtime == rhs.runtime &&
      lhs.trailer == rhs.trailer &&
      lhs.homepage == rhs.homepage &&
      lhs.language == rhs.language &&
      lhs.genres == rhs.genres
  }
}
