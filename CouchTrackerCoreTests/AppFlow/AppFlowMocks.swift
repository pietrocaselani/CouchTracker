@testable import CouchTrackerCore

enum AppFlowMocks {
  final class ModuleDataSource: AppFlowModuleDataSource {
    var modulePagesInvoked = false

    var modulePages: [ModulePage] {
      modulePagesInvoked = true
      return ModulePageMocks.createPages(count: 3)
    }
  }

  final class Repository: AppFlowRepository {
    var lastSelectedTabInvoked = false
    var lastSelectedTabParameter: Int?

    var lastSelectedTab: Int = 0 {
      didSet {
        lastSelectedTabInvoked = true
        lastSelectedTabParameter = lastSelectedTab
      }
    }
  }
}
