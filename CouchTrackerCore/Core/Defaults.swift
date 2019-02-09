import TraktSwift

public enum Defaults {
  public static let showsSyncOptions = WatchedShowEntitiesSyncOptions(extended: Extended.fullEpisodes,
                                                                      hiddingSpecials: false)
  public static let appState = AppState(userSettings: nil, hideSpecials: false)

  public static let itemsPerPage = 30
}
