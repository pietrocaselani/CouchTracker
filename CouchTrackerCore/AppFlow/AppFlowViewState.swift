public enum AppFlowViewState {
  case loading
  case showing(pages: [ModulePage], selectedIndex: Int)
}

extension AppFlowViewState: Hashable {}
