public enum ShowEpisodeViewState: Hashable {
	case loading
	case empty
	case showing(episode: EpisodeEntity)
	case error(error: Error)

	public var hashValue: Int {
		switch self {
		case .loading: return "ShowEpisodeViewState.loading".hashValue
		case .empty: return "ShowEpisodeViewState.empty".hashValue
		case .showing(let episode): return "ShowEpisodeViewState.showing".hashValue ^ episode.hashValue
		case .error(let error): return "ShowEpisodeViewState.error".hashValue ^ error.localizedDescription.hashValue
		}
	}

	public static func == (lhs: ShowEpisodeViewState, rhs: ShowEpisodeViewState) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}