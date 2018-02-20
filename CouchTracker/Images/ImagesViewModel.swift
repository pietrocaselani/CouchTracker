struct ImagesViewModel: Hashable {
	let posterLink: String?
	let backdropLink: String?

	var hashValue: Int {
		var hash = 0

		if let posterLinkHash = posterLink?.hashValue {
			hash = hash ^ posterLinkHash
		}

		if let backdropLinkHash = backdropLink?.hashValue {
			hash = hash ^ backdropLinkHash
		}

		return hash
	}

	static func == (lhs: ImagesViewModel, rhs: ImagesViewModel) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
