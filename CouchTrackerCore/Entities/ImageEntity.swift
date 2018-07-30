public struct ImageEntity: Hashable {
    public let link: String
    public let width: Int
    public let height: Int
    public let iso6391: String?
    public let aspectRatio: Float
    public let voteAverage: Float
    public let voteCount: Int

    public func isBest(then: ImageEntity) -> Bool {
        return voteCount < then.voteCount
    }

    public var hashValue: Int {
        var hash = link.hashValue
        hash = hash ^ width.hashValue
        hash = hash ^ height.hashValue

        if let iso6391Hash = iso6391?.hashValue {
            hash = hash ^ iso6391Hash
        }

        hash = hash ^ aspectRatio.hashValue
        hash = hash ^ voteAverage.hashValue
        hash = hash ^ voteCount.hashValue

        return hash
    }

    public static func == (lhs: ImageEntity, rhs: ImageEntity) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
