import TraktSwift

public enum CouchTrackerCoreStrings {
  public static func addToHistory() -> String {
    return couchTrackerCoreLocalizable(key: "Add to history")
  }

  public static func connectToTrakt() -> String {
    return couchTrackerCoreLocalizable(key: "Connect to Trakt")
  }

  public static func connectedToTrakt() -> String {
    return couchTrackerCoreLocalizable(key: "Connected to Trakt")
  }

  public static func episode() -> String {
    return couchTrackerCoreLocalizable(key: "Episode")
  }

  public static func episodesRemaining(count: Int) -> String {
    return couchTrackerCoreLocalizable(key: "Episodes remaining", count)
  }

  public static func movies() -> String {
    return couchTrackerCoreLocalizable(key: "Movies")
  }

  public static func noMovies() -> String {
    return couchTrackerCoreLocalizable(key: "No movies")
  }

  public static func noShows() -> String {
    return couchTrackerCoreLocalizable(key: "No shows")
  }

  public static func overview() -> String {
    return couchTrackerCoreLocalizable(key: "Overview")
  }

  public static func removeFromHistory() -> String {
    return couchTrackerCoreLocalizable(key: "Remove from history")
  }

  public static func requiresTraktLogin() -> String {
    return couchTrackerCoreLocalizable(key: "Requires Trakt login")
  }

  public static func search() -> String {
    return couchTrackerCoreLocalizable(key: "Search")
  }

  public static func seasons() -> String {
    return couchTrackerCoreLocalizable(key: "Seasons")
  }

  public static func settings() -> String {
    return couchTrackerCoreLocalizable(key: "Settings")
  }

  public static func shortDateFormat() -> String {
    return couchTrackerCoreLocalizable(key: "Short date format")
  }

  public static func showStatus(status: Status) -> String {
    return couchTrackerCoreLocalizable(key: status.rawValue)
  }

  public static func shows() -> String {
    return couchTrackerCoreLocalizable(key: "Shows")
  }

  public static func showsNow() -> String {
    return couchTrackerCoreLocalizable(key: "Shows now")
  }

  public static func showsProgress() -> String {
    return couchTrackerCoreLocalizable(key: "Show progress")
  }

  public static func toBeAnnounced() -> String {
    return couchTrackerCoreLocalizable(key: "To Be Announced")
  }

  public static func trending() -> String {
    return couchTrackerCoreLocalizable(key: "Trending")
  }

  public static func unknown() -> String {
    return couchTrackerCoreLocalizable(key: "Unknown")
  }

  public static func unwatched() -> String {
    return couchTrackerCoreLocalizable(key: "Unwatched")
  }
}
