@testable import CouchTrackerCore

final class ShowManagerMocks {
	private init() {
		Swift.fatalError("No instances for you!")
	}

	final class ModuleCreator: ShowManagerModuleCreator {
		func createModule(for option: ShowManagerOption) -> BaseView {
			return BaseViewMock(title: option.rawValue)
		}
	}

	final class View: ShowManagerView {
		var titleInvoked = false
		var showInvoked = false

		var presenter: ShowManagerPresenter!
		var title: String? {
			didSet {
				titleInvoked = true
			}
		}

		func show(pages: [ModulePage], withDefault index: Int) {
			showInvoked = true
		}
	}

	final class DataSource: ShowManagerDataSource {
		var defaultModuleIndexInvoked = false
		var defaultModuleIndexParameter: Int?

		init() {}

		init(show: WatchedShowEntity, creator: ShowManagerModuleCreator) {}

		var showTitle: String? = nil
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
