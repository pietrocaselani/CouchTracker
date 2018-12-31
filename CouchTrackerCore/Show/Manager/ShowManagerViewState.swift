public enum ShowManagerViewState: Hashable {
  case loading
  case showing(title: String?, pages: [ModulePage], index: Int)
}
