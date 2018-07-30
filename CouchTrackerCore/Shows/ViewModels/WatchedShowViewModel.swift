import Foundation

public struct WatchedShowViewModel: Hashable {
    public let title: String
    public let nextEpisode: String?
    public let nextEpisodeDate: String?
    public let status: String
    public let tmdbId: Int?

    public var hashValue: Int {
        var hash = title.hashValue ^ status.hashValue

        nextEpisode.run { hash ^= $0.hashValue }
        nextEpisodeDate.run { hash ^= $0.hashValue }
        tmdbId.run { hash ^= $0.hashValue }

        return hash
    }

    public static func == (lhs: WatchedShowViewModel, rhs: WatchedShowViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
