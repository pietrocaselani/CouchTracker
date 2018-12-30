@testable import CouchTrackerCore

final class ShowsManagerDataSourceMock: ShowsManagerDataSource {
  var defaultModuleIndexInvoked = false
  var defaultModuleIndexParameter: Int?

  var options: [ShowsManagerOption]
  var modulePages: [ModulePage]
  var defaultModuleIndex: Int {
    didSet {
      defaultModuleIndexInvoked = true
      defaultModuleIndexParameter = defaultModuleIndex
    }
  }

  init(creator _: ShowsManagerModuleCreator) {
    options = [.progress, .now, .trending]
    modulePages = [ModulePage]()
    defaultModuleIndex = 0
  }

  init(options: [ShowsManagerOption] = [.progress, .now, .trending], modulePages: [ModulePage], index: Int = 0) {
    self.options = options
    self.modulePages = modulePages
    defaultModuleIndex = index
  }
}

final class ShowsManagerCreatorMock: ShowsManagerModuleCreator {
  func createModule(for _: ShowsManagerOption) -> BaseView {
    return BaseViewMock()
  }
}
