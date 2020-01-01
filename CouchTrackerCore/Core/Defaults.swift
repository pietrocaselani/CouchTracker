import TraktSwift

public enum Defaults {
  public static let showsSyncOptions = WatchedShowEntitiesSyncOptions(extended: .full,
                                                                      hiddingSpecials: false,
                                                                      seasonExtended: [.full, .episodes])
  public static let appState = AppState(userSettings: nil, hideSpecials: false)

  public static let itemsPerPage = 30
}
