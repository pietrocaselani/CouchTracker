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

  var episode: WatchedEpisodeEntity? {
    switch self {
    case .showing(let episode, _):
      return episode
    case let .showingEpisode(episode):
      return episode
    default: return nil
    }
  }

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading: hasher.combine("ShowEpisodeViewState.loading")
    case .empty: hasher.combine("ShowEpisodeViewState.empty")
    case let .showing(episode, images):
      hasher.combine("ShowEpisodeViewState.showing")
      hasher.combine(episode)
      hasher.combine(images)
    case let .showingEpisode(episode):
      hasher.combine("ShowEpisodeViewState.showingEpisode")
      hasher.combine(episode)
    case let .error(error):
      hasher.combine("ShowEpisodeViewState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: ShowEpisodeViewState, rhs: ShowEpisodeViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading): return true
    case (.empty, .empty): return true
    case let (.showingEpisode(lhsEpisode), .showingEpisode(rhsEpisode)):
      return lhsEpisode == rhsEpisode
    case let (.showing(lhsEpisode, lhsImage), .showing(rhsEpisode, rhsImages)):
      return lhsEpisode == rhsEpisode && lhsImage == rhsImages
    case let (.error(lhsError), .error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
