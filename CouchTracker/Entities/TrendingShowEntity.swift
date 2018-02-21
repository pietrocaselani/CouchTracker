public struct TrendingShowEntity: Hashable {
	public let show: ShowEntity

	public var hashValue: Int {
		return show.hashValue
	}

	public static func == (lhs: TrendingShowEntity, rhs: TrendingShowEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
