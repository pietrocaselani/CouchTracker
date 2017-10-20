import ObjectMapper

public struct SyncSeason: ImmutableMappable {
  public let number: Int
  public let watchedAt: Date
  public let episodes: [SyncEpisode]?
  public let collectedAt, ratedAt: Date?
  public let rating: Rating?
  
  public init(number: Int, watchedAt: Date, episodes: [SyncEpisode]?, collectedAt: Date?, ratedAt: Date?, rating: Rating?) {
    self.number = number
    self.watchedAt = watchedAt
    self.episodes = episodes
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }
  
  public init(map: Map) throws {
    self.number = try map.value("number")
    self.watchedAt = try map.value("watched_at")
    self.episodes = try? map.value("episodes")
    self.collectedAt = try? map.value("collected_at")
    self.ratedAt = try? map.value("rated_at")
    self.rating = try? map.value("rating")
  }
  
  public func mapping(map: Map) {
    self.number >>> map["number"]
    self.watchedAt >>> map["watched_at"]
    self.episodes >>> map["episodes"]
    self.collectedAt >>> map["collected_at"]
    self.ratedAt >>> map["rated_at"]
    self.rating >>> map["rating"]
  }  
}
