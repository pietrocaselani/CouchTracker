@testable import CouchTrackerCore

final class MoviesManagerMocks {
    private init() {
        Swift.fatalError("No instances for you!")
    }

    final class View: MoviesManagerView {
        var showPagesInvoked = false
        var showPagesParameters: (pages: [ModulePage], index: Int)?
        var presenter: MoviesManagerPresenter!

        func show(pages: [ModulePage], withDefault index: Int) {
            showPagesInvoked = true
            showPagesParameters = (pages, index)
        }
    }

    final class DataSource: MoviesManagerDataSource {
        var options: [MoviesManagerOption]

        var modulePages: [ModulePage]

        var defaultModuleIndex: Int

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
