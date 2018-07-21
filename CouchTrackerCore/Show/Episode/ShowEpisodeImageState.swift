import Foundation

public enum ShowEpisodeImageState: Hashable {
	case loading
	case none
	case image(url: URL)
	case error(error: Error)

	public var hashValue: Int {
		switch self {
		case .loading: return "ShowEpisodeViewState.loading".hashValue
		case .none: return "ShowEpisodeViewState.none".hashValue
		case .image(let url): return "ShowEpisodeViewState.image".hashValue ^ url.hashValue
		case .error(let error): return "ShowEpisodeViewState.error".hashValue ^ error.localizedDescription.hashValue
		}
	}

	public static func == (lhs: ShowEpisodeImageState, rhs: ShowEpisodeImageState) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
