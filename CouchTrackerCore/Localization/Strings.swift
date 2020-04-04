import TraktSwift

public enum CouchTrackerCoreStrings {
  public static func addToHistory() -> String {
    couchTrackerCoreLocalizable(key: "Add to history")
  }

  public static func connectToTrakt() -> String {
    couchTrackerCoreLocalizable(key: "Connect to Trakt")
  }

  public static func connectedToTrakt() -> String {
    couchTrackerCoreLocalizable(key: "Connected to Trakt")
  }

  public static func episode() -> String {
    couchTrackerCoreLocalizable(key: "Episode")
  }

  public static func episodesRemaining(count: Int) -> String {
    couchTrackerCoreLocalizable(key: "Episodes remaining", count)
  }

  public static func movies() -> String {
    couchTrackerCoreLocalizable(key: "Movies")
  }

  public static func noMovies() -> String {
    couchTrackerCoreLocalizable(key: "No movies")
  }

  public static func noShows() -> String {
    couchTrackerCoreLocalizable(key: "No shows")
  }

  public static func overview() -> String {
    couchTrackerCoreLocalizable(key: "Overview")
  }

  public static func removeFromHistory() -> String {
    couchTrackerCoreLocalizable(key: "Remove from history")
  }

  public static func requiresTraktLogin() -> String {
    couchTrackerCoreLocalizable(key: "Requires Trakt login")
  }

  public static func search() -> String {
    couchTrackerCoreLocalizable(key: "Search")
  }

  public static func seasons() -> String {
    couchTrackerCoreLocalizable(key: "Seasons")
  }

  public static func settings() -> String {
    couchTrackerCoreLocalizable(key: "Settings")
  }

  public static func shortDateFormat() -> String {
    couchTrackerCoreLocalizable(key: "Short date format")
  }

  public static func showStatus(status: Status) -> String {
    couchTrackerCoreLocalizable(key: status.rawValue)
  }

  public static func shows() -> String {
    couchTrackerCoreLocalizable(key: "Shows")
  }

  public static func showsNow() -> String {
    couchTrackerCoreLocalizable(key: "Shows now")
  }

  public static func showsProgress() -> String {
    couchTrackerCoreLocalizable(key: "Show progress")
  }

  public static func toBeAnnounced() -> String {
    couchTrackerCoreLocalizable(key: "To Be Announced")
  }

  public static func trending() -> String {
    couchTrackerCoreLocalizable(key: "Trending")
  }

  public static func unknown() -> String {
    couchTrackerCoreLocalizable(key: "Unknown")
  }

  public static func unwatched() -> String {
    couchTrackerCoreLocalizable(key: "Unwatched")
  }
}
