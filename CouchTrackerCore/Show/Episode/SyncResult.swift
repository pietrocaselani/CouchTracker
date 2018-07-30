public enum SyncResult: Hashable {
    case success(show: WatchedShowEntity)
    case fail(error: Error)

    public var hashValue: Int {
        var hash = 11

        if case let .success(show) = self {
            hash ^= show.hashValue
        }

        return hash
    }

    public static func == (lhs: SyncResult, rhs: SyncResult) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
