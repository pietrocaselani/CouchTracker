public struct MovieDetailsViewModel {
	public let title: String
	public let tagline: String
	public let overview: String
	public let genres: String
	public let releaseDate: String
}

extension MovieDetailsViewModel: Equatable, Hashable {

	public static func == (lhs: MovieDetailsViewModel, rhs: MovieDetailsViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	public var hashValue: Int {
		let hash = title.hashValue ^ releaseDate.hashValue ^ tagline.hashValue
		return hash ^ overview.hashValue ^ genres.hashValue ^ releaseDate.hashValue
	}
}
