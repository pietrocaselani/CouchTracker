public enum ShowOverviewImagesState: Hashable {
	case loading
	case empty
	case showing(images: ImagesViewModel)
	case error (error: Error)

	public var hashValue: Int {
		switch self {
		case .loading: return "ShowOverviewImagesState.loading".hashValue
		case .empty: return "ShowOverviewImagesState.empty".hashValue
		case .showing(let images): return "ShowOverviewImagesState.showing".hashValue ^ images.hashValue
		case .error(let error): return "ShowOverviewImagesState.error".hashValue ^ error.localizedDescription.hashValue
		}
	}

	public static func == (lhs: ShowOverviewImagesState, rhs: ShowOverviewImagesState) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
