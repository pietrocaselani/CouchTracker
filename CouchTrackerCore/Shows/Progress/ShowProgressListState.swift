public struct ShowProgressListState: Hashable {
	public let sort: ShowProgressSort
	public let filter: ShowProgressFilter
	public let direction: ShowProgressDirection

	public static var initialState: ShowProgressListState {
		return ShowProgressListState(sort: .title, filter: .none, direction: .asc)
	}

	public static func newBuilder() -> Builder {
		return Builder()
	}

	public init(sort: ShowProgressSort, filter: ShowProgressFilter, direction: ShowProgressDirection) {
		self.sort = sort
		self.filter = filter
		self.direction = direction
	}

	public func builder() -> Builder {
		return Builder(state: self)
	}

	public final class Builder {
		public var sort: ShowProgressSort
		public var filter: ShowProgressFilter
		public var direction: ShowProgressDirection

		init(state: ShowProgressListState = ShowProgressListState.initialState) {
			sort = state.sort
			filter = state.filter
			direction = state.direction
		}

		public func build() -> ShowProgressListState {
			return ShowProgressListState(sort: sort, filter: filter, direction: direction)
		}
	}
}
