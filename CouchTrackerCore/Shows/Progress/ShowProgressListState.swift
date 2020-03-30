public struct ShowProgressListState: Hashable {
  public let sort: ShowProgressSort
  public let filter: ShowProgressFilter
  public let direction: ShowProgressDirection

  public static var initialState: ShowProgressListState {
    ShowProgressListState(sort: .title, filter: .none, direction: .asc)
  }

  public static func newBuilder() -> Builder {
    Builder()
  }

  public init(sort: ShowProgressSort, filter: ShowProgressFilter, direction: ShowProgressDirection) {
    self.sort = sort
    self.filter = filter
    self.direction = direction
  }

  public func builder() -> Builder {
    Builder(state: self)
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
      ShowProgressListState(sort: sort, filter: filter, direction: direction)
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
