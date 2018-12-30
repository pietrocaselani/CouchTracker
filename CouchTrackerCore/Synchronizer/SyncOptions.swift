import TraktSwift

public enum SeasonSyncOptions {
  case none
  case yes(number: Int?, extended: Extended)
}

public struct WatchedShowEntitySyncOptions {
  public let episodeExtended: Extended
  public let seasonOptions: SeasonSyncOptions
  public let hiddingSpecials: Bool
  public let showIds: ShowIds

  public init(showIds: ShowIds, episodeExtended: Extended, seasonOptions: SeasonSyncOptions, hiddingSpecials: Bool) {
    self.showIds = showIds
    self.episodeExtended = episodeExtended
    self.seasonOptions = seasonOptions
    self.hiddingSpecials = hiddingSpecials
  }
}

public struct WatchedShowEntitiesSyncOptions {
  public let extended: Extended
  public let hiddingSpecials: Bool

  public init(extended: Extended, hiddingSpecials: Bool) {
    self.extended = extended
    self.hiddingSpecials = hiddingSpecials
  }
}
