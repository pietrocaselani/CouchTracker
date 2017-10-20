final class ShowsManagerViewMock: ShowsManagerView {
  var presenter: ShowsManagerPresenter!
  var showOptionsSelectionInvoked = false
  var showOptionsSelectionParameters: [String]?

  func showOptionsSelection(with titles: [String]) {
    showOptionsSelectionInvoked = true
    showOptionsSelectionParameters = titles
  }
}

final class ShowsManagerRouterMock: ShowsManagerRouter {
  var showNeedsLoginInvoked = false
  var showOptionInvoked = false
  var showOptionParameters: ShowsManagerOption?

  func showNeedsLogin() {
    showNeedsLoginInvoked = true
  }

  func show(option: ShowsManagerOption) {
    showOptionInvoked = true
    showOptionParameters = option
  }
}
