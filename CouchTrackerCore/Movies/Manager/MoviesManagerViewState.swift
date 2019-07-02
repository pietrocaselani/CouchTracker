public enum MoviesManagerViewState: Hashable, EnumPoetry {
  case loading
  case showing(pages: [ModulePage], selectedIndex: Int)
}
