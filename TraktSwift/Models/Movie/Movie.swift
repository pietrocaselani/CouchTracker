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

  public override var hashValue: Int {
    var hash = super.hashValue ^ ids.hashValue

    if let yearHash = year?.hashValue {
      hash = hash ^ yearHash
    }

    if let certificationHash = certification?.hashValue {
      hash = hash ^ certificationHash
    }

    if let taglineHash = tagline?.hashValue {
      hash = hash ^ taglineHash
    }

    if let releasedHash = released?.hashValue {
      hash = hash ^ releasedHash
    }

    if let runtimeHash = runtime?.hashValue {
      hash = hash ^ runtimeHash
    }

    if let trailerHash = trailer?.hashValue {
      hash = hash ^ trailerHash
    }

    if let homepageHash = homepage?.hashValue {
      hash = hash ^ homepageHash
    }

    if let languageHash = language?.hashValue {
      hash = hash ^ languageHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }
}
