public enum ShowOverviewViewState: Hashable {
    case loading
    case showing(show: ShowEntity)
    case error(error: Error)

    public var hashValue: Int {
        switch self {
        case .loading: return "ShowOverviewViewState.loading".hashValue
        case let .showing(show): return "ShowOverviewViewState.shwoing".hashValue ^ show.hashValue
        case let .error(error): return "ShowOverviewViewState.error".hashValue ^ error.localizedDescription.hashValue
        }
    }

    public static func == (lhs: ShowOverviewViewState, rhs: ShowOverviewViewState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
