import TraktSwift

public struct WatchedSeasonEntity: Hashable {
    public let showIds: ShowIds
    public let number: Int
    public let aired: Int?
    public let completed: Int?
    public let episodes: [WatchedEpisodeEntity]

    public var hashValue: Int {
        var hash = showIds.hashValue
        hash ^= number.hashValue
        aired.run { hash ^= $0.hashValue }
        completed.run { hash ^= $0.hashValue }

        episodes.forEach { hash ^= $0.hashValue }

        return hash
    }

    public static func == (lhs: WatchedSeasonEntity, rhs: WatchedSeasonEntity) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
