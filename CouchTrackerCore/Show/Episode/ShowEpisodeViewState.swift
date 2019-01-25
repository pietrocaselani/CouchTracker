import Foundation

public struct ShowEpisodeImages: Hashable {
  public let posterURL: URL
  public let previewURL: URL
}

public enum ShowEpisodeViewState: Hashable {
  case loading
  case empty
  case showingEpisode(episode: WatchedEpisodeEntity)
  case showing(episode: WatchedEpisodeEntity, images: ShowEpisodeImages)
  case error(error: Error)

  public var hashValue: Int {
    switch self {
    case .loading: return "ShowEpisodeViewState.loading".hashValue
    case .empty: return "ShowEpisodeViewState.empty".hashValue
    case let .error(error): return "ShowEpisodeViewState.error".hashValue ^ error.localizedDescription.hashValue
    case let .showing(episode, images):
      return "ShowEpisodeViewState.showing".hashValue ^ episode.hashValue ^ images.hashValue
    case let .showingEpisode(episode):
      return "ShowEpisodeViewState.showingEpisode".hashValue ^ episode.hashValue
    }
  }

  var episode: WatchedEpisodeEntity? {
    switch self {
    case .showing(let episode, _):
      return episode
    case let .showingEpisode(episode):
      return episode
    default: return nil
    }
  }

  public static func == (lhs: ShowEpisodeViewState, rhs: ShowEpisodeViewState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
