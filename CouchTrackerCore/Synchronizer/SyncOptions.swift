import TraktSwift

public enum SeasonSyncOptions {
  case none
  case yes(number: Int?, extended: [Extended])
}

public struct WatchedShowEntitySyncOptions {
  public let episodeExtended: Extended
  public let seasonOptions: SeasonSyncOptions
  public let hidingSpecials: Bool
  public let showIds: ShowIds

  public init(showIds: ShowIds, episodeExtended: Extended, seasonOptions: SeasonSyncOptions, hidingSpecials: Bool) {
    self.showIds = showIds
    self.episodeExtended = episodeExtended
    self.seasonOptions = seasonOptions
    self.hidingSpecials = hidingSpecials
  }
}

public struct WatchedShowEntitiesSyncOptions {
  public let extended: Extended
  public let hidingSpecials: Bool
  public let seasonExtended: [Extended]

  public init(extended: Extended, hidingSpecials: Bool, seasonExtended: [Extended]) {
    self.extended = extended
    self.hidingSpecials = hidingSpecials
    self.seasonExtended = seasonExtended
  }
}
