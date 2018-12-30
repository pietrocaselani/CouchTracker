public enum ShowsManagerViewState: Hashable {
  case loading
  case showing(pages: [ModulePage], selectedIndex: Int)
}
