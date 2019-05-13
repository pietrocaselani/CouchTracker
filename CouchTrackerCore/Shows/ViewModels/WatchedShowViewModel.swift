import Foundation

public struct WatchedShowViewModel: Hashable {
  public let title: String
  public let nextEpisode: String?
  public let nextEpisodeDate: String?
  public let status: String
  public let tmdbId: Int?

  public init(title: String, nextEpisode: String?, nextEpisodeDate: String?, status: String, tmdbId: Int?) {
    self.title = title
    self.nextEpisode = nextEpisode
    self.nextEpisodeDate = nextEpisodeDate
    self.status = status
    self.tmdbId = tmdbId
  }
}
