final class ShowsManageriOSModuleSetup: ShowsManagerDataSource {
	var options: [ShowsManagerOption] {
		let progress = ShowsManagerOption.progress
		let now = ShowsManagerOption.now
		let trending = ShowsManagerOption.trending

		return [progress, now, trending]
	}

	var modulePages: [ShowManagerModulePage] {
		let pages = options.map { option -> ShowManagerModulePage in
			let view = moduleViewFor(option: option)
			let name = moduleNameFor(option: option)

			return ShowManagerModulePage(page: view, title: name)
		}

		return pages
	}

	var defaultModuleIndex: Int {
		//TODO inject app config repository or something like that, to get the last selected module
		return 0
	}

	private func moduleNameFor(option: ShowsManagerOption) -> String {
		switch option {
		case .progress:
			return "Progress"
		case .now:
			return "Now"
		case .trending:
			return "Trending"
		}
	}

	private func moduleViewFor(option: ShowsManagerOption) -> BaseView {
		switch option {
		case .progress:
			return ShowsProgressModule.setupModule()
		case .now:
			return ShowsNowModule.setupModule()
		case .trending:
			return TrendingModule.setupModule(for: .shows)
		}
	}
}
