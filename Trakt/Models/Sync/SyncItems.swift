import ObjectMapper

public struct SyncItems: ImmutableMappable {
  public let movies: [SyncMovie]?
  public let shows: [SyncShow]?
  public let episodes: [SyncEpisode]?
  public let ids: [Int]?
  
  public init(movies: [SyncMovie]? = nil, shows: [SyncShow]? = nil, episodes: [SyncEpisode]? = nil, ids: [Int]? = nil) {
    self.movies = movies
    self.shows = shows
    self.episodes = episodes
    self.ids = ids
  }
  
  public init(map: Map) throws {
    self.movies = try? map.value("movies")
    self.shows = try? map.value("shows")
    self.episodes = try? map.value("episodes")
    self.ids = try? map.value("ids")
  }
  
  public func mapping(map: Map) {
    self.movies >>> map["movies"]
    self.shows >>> map["shows"]
    self.episodes >>> map["episodes"]
    self.ids >>> map["ids"]
  }  
}
