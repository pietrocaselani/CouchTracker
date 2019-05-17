import Foundation

public final class BaseMovie: Codable, Hashable {
  public let movie: Movie?
  public let collectedAt: Date?
  public let watchedAt: Date?
  public let listedAt: Date?
  public let plays: Int?

  private enum CodingKeys: String, CodingKey {
    case movie, plays
    case collectedAt = "collected_at"
    case watchedAt = "watched_at"
    case listedAt = "listed_at"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    movie = try container.decodeIfPresent(Movie.self, forKey: .movie)
    plays = try container.decodeIfPresent(Int.self, forKey: .plays)

    let collectedAt = try container.decodeIfPresent(String.self, forKey: .collectedAt)
    let listedAt = try container.decodeIfPresent(String.self, forKey: .listedAt)
    let watchedAt = try container.decodeIfPresent(String.self, forKey: .watchedAt)

    self.collectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(collectedAt)
    self.listedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(listedAt)
    self.watchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(watchedAt)
  }

  public var hashValue: Int {
    var hash = 11

    if let movieHash = movie?.hashValue {
      hash ^= movieHash
    }

    if let collectedAtHash = collectedAt?.hashValue {
      hash ^= collectedAtHash
    }

    if let watchedAtHash = watchedAt?.hashValue {
      hash ^= watchedAtHash
    }

    if let listedAtHash = listedAt?.hashValue {
      hash ^= listedAtHash
    }

    if let playsHash = plays?.hashValue {
      hash ^= playsHash
    }

    return hash
  }

  public static func == (lhs: BaseMovie, rhs: BaseMovie) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
