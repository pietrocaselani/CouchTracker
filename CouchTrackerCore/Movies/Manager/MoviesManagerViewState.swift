public enum MoviesManagerViewState: Hashable {
  case loading
  case showing(pages: [ModulePage], selectedIndex: Int)
}
