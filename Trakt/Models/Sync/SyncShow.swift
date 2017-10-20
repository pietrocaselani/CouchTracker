import ObjectMapper

public struct SyncShow: ImmutableMappable {
  public let ids: ShowIds
  public let seasons: [SyncSeason]?
  public let collectedAt, watchedAt, ratedAt: Date?
  public let rating: Rating?
  
  public init(ids: ShowIds, seasons: [SyncSeason]?, collectedAt: Date?, watchedAt: Date?, ratedAt: Date?, rating: Rating?) {
    self.ids = ids
    self.seasons = seasons
    self.collectedAt = collectedAt
    self.watchedAt = watchedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }
  
  public init(map: Map) throws {
    self.ids = try map.value("ids")
    self.watchedAt = try? map.value("watched_at")
    self.seasons = try? map.value("seasons")
    self.collectedAt = try? map.value("collected_at")
    self.rating = try? map.value("rating")
    self.ratedAt = try? map.value("rated_at")
  }
  
  public func mapping(map: Map) {
    self.ids >>> map["ids"]
    self.watchedAt >>> map["watched_at"]
    self.seasons >>> map["seasons"]
    self.collectedAt >>> map["collected_at"]
    self.rating >>> map["rating"]
    self.ratedAt >>> map["rated_at"]
  }
}
