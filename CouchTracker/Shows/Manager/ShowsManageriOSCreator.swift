import CouchTrackerCore

final class ShowsManageriOSCreator: ShowsManagerModuleCreator {
	func createModule(for option: ShowsManagerOption) -> BaseView {
		switch option {
		case .progress:
			return ShowsProgressModule.setupModule()
		case .now:
			return ShowsNowModule.setupModule()
		case .trending:
			return TrendingModule.setupModule(for: .shows)
		case .search:
			return SearchModule.setupModule(searchTypes: [.show])
		}
	}
}
