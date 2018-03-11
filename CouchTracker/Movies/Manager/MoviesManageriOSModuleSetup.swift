import CouchTrackerCore

final class MoviesManageriOSModuleCreator: MoviesManagerModuleCreator {
	func createModule(for option: MoviesManagerOption) -> BaseView {
		switch option {
			case .trending:
				return TrendingModule.setupModule(for: .movies)
		}
	}
}
