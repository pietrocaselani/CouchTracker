final class ShowsManageriOSModuleSetup: ShowsManagerDataSource {
	private let creator: ShowsManagerModuleCreator

	init(creator: ShowsManagerModuleCreator) {
		self.creator = creator
	}

	var options: [ShowsManagerOption] {
		let progress = ShowsManagerOption.progress
		let now = ShowsManagerOption.now
		let trending = ShowsManagerOption.trending

		return [progress, now, trending]
	}

	var modulePages: [ModulePage] {
		let pages = options.map { option -> ModulePage in
			let view = self.creator.createModule(for: option)
			let name = moduleNameFor(option: option)

			return ModulePage(page: view, title: name)
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
}
