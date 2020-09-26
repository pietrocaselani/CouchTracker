public struct SyncErrors: Codable {
  public let movies: [SyncMovie]?
  public let shows: [SyncShow]?
  public let seasons: [SyncSeason]?
  public let episodes: [SyncEpisode]?
  public let ids: [Int]?
}
