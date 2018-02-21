public struct ShowDetailsViewModel: Hashable {
	public let title: String
	public let overview: String
	public let network: String
	public let genres: String
	public let firstAired: String
	public let status: String

	public var hashValue: Int {
		var hash = title.hashValue ^ overview.hashValue
		hash = hash ^ network.hashValue ^ genres.hashValue
		hash = hash ^ firstAired.hashValue ^ status.hashValue
		return hash
	}

	public static func == (lhs: ShowDetailsViewModel, rhs: ShowDetailsViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
