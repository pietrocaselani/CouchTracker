import TMDBSwift

extension Movies: Hashable {
	public var hashValue: Int {
		switch self {
		case .images(let movieId):
			return self.path.hashValue ^ movieId.hashValue
		}
	}

	public static func == (lhs: Movies, rhs: Movies) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
