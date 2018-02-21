import CouchTrackerCore

final class ShowManageriOSModuleSetup: ShowManagerDataSource {
	private let show: WatchedShowEntity
	var showTitle: String?
	var options: [ShowManagerOption]
	var defaultModuleIndex: Int = 0 //TODO inject repository to get last selected module

	init(show: WatchedShowEntity) {
		self.show = show
		self.showTitle = show.show.title

		let overview = ShowManagerOption.overview
		let episode = ShowManagerOption.episode
		let seasons = ShowManagerOption.seasons

		self.options = [overview, episode, seasons]
	}

	var modulePages: [ModulePage] {
		return options.map {
			let view = moduleViewFor(option: $0)
			let name = moduleNameFor(option: $0)
			return ModulePage(page: view, title: name)
		}
	}

	private func moduleNameFor(option: ShowManagerOption) -> String {
		switch option {
		case .episode:
			return "Episode"
		case .overview:
			return "Overview"
		case .seasons:
			return "Seasons"
		}
	}

	private func moduleViewFor(option: ShowManagerOption) -> BaseView {
		switch option {
		case .episode:
			return ShowEpisodeModule.setupModule(for: show)
		case .overview:
			return ShowOverviewModule.setupModule()
		case .seasons:
			return ShowSeasonsModule.setupModule()
		}
	}
}
