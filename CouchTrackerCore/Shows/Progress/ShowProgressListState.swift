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

  public var hashValue: Int {
    return sort.hashValue ^ filter.hashValue ^ direction.hashValue
  }

  public static func == (lhs: ShowProgressListState, rhs: ShowProgressListState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public func builder() -> Builder {
    return Builder(state: self)
  }

  public final class Builder {
    private var sort: ShowProgressSort
    private var filter: ShowProgressFilter
    private var direction: ShowProgressDirection

    init(state: ShowProgressListState = ShowProgressListState.initialState) {
      sort = state.sort
      filter = state.filter
      direction = state.direction
    }

    public func build() -> ShowProgressListState {
      return ShowProgressListState(sort: sort, filter: filter, direction: direction)
    }

    func sort(_ sort: ShowProgressSort) -> Builder {
      self.sort = sort
      return self
    }

    func filter(_ filter: ShowProgressFilter) -> Builder {
      self.filter = filter
      return self
    }

    func direction(_ direction: ShowProgressDirection) -> Builder {
      self.direction = direction
      return self
    }

    func toggleDirection() -> Builder {
      direction = direction.toggle()
      return self
    }
  }
}
