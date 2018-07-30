public enum SyncMovieResult: Hashable {
    case success
    case fail(error: Error)

    public var hashValue: Int {
        var hash = 13

        if case let .fail(error) = self {
            hash ^= error.localizedDescription.hashValue
        }

        return hash
    }

    public static func == (lhs: SyncMovieResult, rhs: SyncMovieResult) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
