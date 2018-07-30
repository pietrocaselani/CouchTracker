public struct ImagesViewModel: Hashable {
    public let posterLink: String?
    public let backdropLink: String?

    public var hashValue: Int {
        var hash = 0

        if let posterLinkHash = posterLink?.hashValue {
            hash = hash ^ posterLinkHash
        }

        if let backdropLinkHash = backdropLink?.hashValue {
            hash = hash ^ backdropLinkHash
        }

        return hash
    }

    public static func == (lhs: ImagesViewModel, rhs: ImagesViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
