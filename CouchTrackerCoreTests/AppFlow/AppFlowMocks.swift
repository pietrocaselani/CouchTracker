@testable import CouchTrackerCore

final class AppFlowMocks {
    private init() {
        Swift.fatalError("No instances for you!")
    }

    final class ModuleDataSource: AppFlowModuleDataSource {
        var modulePagesInvoked = false

        var modulePages: [ModulePage] {
            modulePagesInvoked = true
            return ModulePageMocks.createPages(count: 3)
        }
    }

    final class View: AppFlowView {
        var presenter: AppFlowPresenter!

        var showPagesInvoked = false
        var showPagesParameters: (pages: [ModulePage], selectedIndex: Int)?

        func show(pages: [ModulePage], selectedIndex: Int) {
            showPagesInvoked = true
            showPagesParameters = (pages, selectedIndex)
        }
    }

    final class Interactor: AppFlowInteractor {
        var lastSelectedTabInvoked = false
        var lastSelectedTabParameter: Int?

        var lastSelectedTab: Int = 0 {
            didSet {
                lastSelectedTabInvoked = true
                lastSelectedTabParameter = lastSelectedTab
            }
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
