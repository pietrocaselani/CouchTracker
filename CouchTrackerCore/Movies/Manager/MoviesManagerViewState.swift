public enum MoviesManagerViewState: Hashable, EnumPoetry {
  case loading
  case showing(pages: [ModulePage], selectedIndex: Int)
}

extension MoviesManagerViewState {
    var showing: (pages: [ModulePage], selectedIndex: Int)? {
        guard case let .showing(pages, x) = self else { return nil }
        return (pages: pages, selectedIndex: x)
    }
}
