import ObjectMapper

public class BaseIds: ImmutableMappable, Hashable, CustomStringConvertible {
  public let trakt: Int
  public let tmdb: Int?
  public let imdb: String?

  public init(trakt: Int, tmdb: Int?, imdb: String?) {
    self.trakt = trakt
    self.tmdb = tmdb
    self.imdb = imdb
  }

  public required init(map: Map) throws {
    self.trakt = try map.value("trakt")
    self.tmdb = try? map.value("tmdb")
    self.imdb = try? map.value("imdb")
  }

  public func mapping(map: Map) {
    self.trakt >>> map["trakt"]
    self.tmdb >>> map["tmdb"]
    self.imdb >>> map["imdb"]
  }

  public var hashValue: Int {
    var hash = trakt.hashValue

    if let tmdbHash = tmdb?.hashValue {
      hash = hash ^ tmdbHash
    }

    if let imdbHash = imdb?.hashValue {
      hash = hash ^ imdbHash
    }

    return hash
  }

  public static func == (lhs: BaseIds, rhs: BaseIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public var description: String {
    return "trakt: \(trakt), tmdb: \(String(describing: tmdb)), imdb: \(String(describing: imdb))"
  }
}
