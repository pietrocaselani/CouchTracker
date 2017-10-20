import ObjectMapper

public final class SeasonIds: ImmutableMappable, Hashable {
  public let tvdb: Int
  public let tmdb: Int
  public let trakt: Int
  public let tvrage: Int?
  
  public required init(map: Map) throws {
    self.tvdb = try map.value("tvdb")
    self.tmdb = try map.value("tmdb")
    self.trakt = try map.value("trakt")
    self.tvrage = try? map.value("tvrage")
  }
  
  public func mapping(map: Map) {
    self.tvdb >>> map["tvdb"]
    self.tmdb >>> map["tmdb"]
    self.trakt >>> map["trakt"]
    self.tvrage >>> map["tvrage"]
  }
  
  public var hashValue: Int {
    var hash = tvdb.hashValue ^ tmdb.hashValue ^ trakt.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    
    return hash
  }
  
  public static func == (lhs: SeasonIds, rhs: SeasonIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
