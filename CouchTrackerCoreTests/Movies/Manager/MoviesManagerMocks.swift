@testable import CouchTrackerCore

enum MoviesManagerMocks {
  final class DataSource: MoviesManagerDataSource {
    var defaultModuleIndexInvokedCount = 0
    var options: [MoviesManagerOption]
    var modulePages: [ModulePage]
    var defaultModuleIndex: Int {
      didSet {
        defaultModuleIndexInvokedCount += 1
      }
    }

    init(creator _: MoviesManagerModuleCreator) {
      defaultModuleIndex = 2
      options = [MoviesManagerOption.trending]
      modulePages = ModulePageMocks.createPages(titles: ["Trending"])
    }
  }

  final class ModuleCreator: MoviesManagerModuleCreator {
    func createModule(for option: MoviesManagerOption) -> BaseView {
      return BaseViewMock(title: option.rawValue)
    }
  }
}
