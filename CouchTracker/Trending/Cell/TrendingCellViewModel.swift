public struct TrendingCellViewModel: Hashable {
	public let title: String

	public var hashValue: Int {
		return title.hashValue
	}

	public static func == (lhs: TrendingCellViewModel, rhs: TrendingCellViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
