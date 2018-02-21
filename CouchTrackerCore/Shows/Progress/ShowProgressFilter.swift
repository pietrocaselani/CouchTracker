import TraktSwift

enum ShowProgressFilter: String {
	case none
	case watched
	case returning
	case returningWatched

	static func allValues() -> [ShowProgressFilter] {
		return [.none, .watched, .returning, returningWatched]
	}

	static func filter(for index: Int) -> ShowProgressFilter {
		let allValues = ShowProgressFilter.allValues()
		if index < 0 || index >= allValues.count {
			return ShowProgressFilter.none
		}

		return allValues[index]
	}

	func index() -> Int {
		return ShowProgressFilter.allValues().index(of: self) ?? 0
	}

	func filter() -> (WatchedShowEntity) -> Bool {
		if self == .none { return filterNone() }
		if self == .watched { return filterWatched() }
		if self == .returning { return filterReturning() }
		return filterReturningWatched()
	}

	private func filterNone() -> (WatchedShowEntity) -> Bool {
		return { (entity: WatchedShowEntity) in return true }
	}

	private func filterWatched() -> (WatchedShowEntity) -> Bool {
		return { (entity: WatchedShowEntity) in return entity.aired - entity.completed > 0 }
	}

	private func filterReturning() -> (WatchedShowEntity) -> Bool {
		return { (entity: WatchedShowEntity) in return entity.show.status == Status.returning }
	}

	private func filterReturningWatched() -> (WatchedShowEntity) -> Bool {
		return { (entity: WatchedShowEntity) in
			return entity.aired - entity.completed > 0 || entity.show.status == Status.returning
		}
	}
}
