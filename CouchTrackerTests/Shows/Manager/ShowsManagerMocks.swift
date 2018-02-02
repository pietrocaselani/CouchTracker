final class ShowsManagerViewMock: ShowsManagerView {
  var presenter: ShowsManagerPresenter!
  var showNeedsTraktLoginInvoked = false
  var showPagesInvoked = false
  var showPagesParameters: (pages: [ModulePage], index: Int)? = nil

  func show(pages: [ModulePage], withDefault index: Int) {
    showPagesInvoked = true
    showPagesParameters = (pages, index)
  }

  func showNeedsTraktLogin() {
    showNeedsTraktLoginInvoked = true
  }
}

final class ShowsManagerDataSourceMock: ShowsManagerDataSource {
  var options: [ShowsManagerOption]
  var modulePages: [ModulePage]
  var defaultModuleIndex: Int

  init(options: [ShowsManagerOption] = [.progress, .now, .trending],
       modulePages: [ModulePage], index: Int = 0) {
    self.options = options
    self.modulePages = modulePages
    self.defaultModuleIndex = index
  }
}
