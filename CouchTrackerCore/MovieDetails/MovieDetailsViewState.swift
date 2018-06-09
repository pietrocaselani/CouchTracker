public enum MovieDetailsViewState: Hashable {
	case loading
	case showing(viewModel: MovieDetailsViewModel)
	case error(error: Error)

	public var hashValue: Int {
		switch self {
		case .loading:
			return "MovieDetailsViewState.loading".hashValue
		case .showing(let viewModel):
			return "MovieDetailsViewState.showing".hashValue ^ viewModel.hashValue
		case .error(let error):
			return "MovieDetailsViewState.error".hashValue ^ error.localizedDescription.hashValue
		}
	}

	public static func == (lhs: MovieDetailsViewState, rhs: MovieDetailsViewState) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
