@testable import CouchTrackerCore

enum ShowManagerMocks {
  final class ModuleCreator: ShowManagerModuleCreator {
    func createModule(for option: ShowManagerOption) -> BaseView {
      return BaseViewMock(title: option.rawValue)
    }
  }

  final class DataSource: ShowManagerDataSource {
    var defaultModuleIndexInvoked = false
    var defaultModuleIndexParameter: Int?

    init() {}

    init(show _: WatchedShowEntity, creator _: ShowManagerModuleCreator) {}

    var showTitle: String?
    var options: [ShowManagerOption] = []
    var modulePages: [ModulePage] = []
    var defaultModuleIndex: Int = 0 {
      didSet {
        defaultModuleIndexInvoked = true
        defaultModuleIndexParameter = defaultModuleIndex
      }
    }
  }
}
