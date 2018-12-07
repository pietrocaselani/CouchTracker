import TraktSwift

public enum Defaults {
  public static let showsSyncOptions = WatchedShowEntitiesSyncOptions(extended: Extended.fullEpisodes,
                                                                      hiddingSpecials: false)
  public static let appState = AppConfigurationsState(loginState: .notLogged, hideSpecials: false)
}
