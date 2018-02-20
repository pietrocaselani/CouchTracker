enum SyncResult: Hashable {
	case success(show: WatchedShowEntity)
	case fail(error: Error)

	var hashValue: Int {
		var hash = 11

		if case .success(let show) = self {
			hash ^= show.hashValue
		}

		return hash
	}

	static func ==(lhs: SyncResult, rhs: SyncResult) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
