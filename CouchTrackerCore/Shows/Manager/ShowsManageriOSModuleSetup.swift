public final class ShowsManageriOSModuleSetup: ShowsManagerDataSource {
	private let creator: ShowsManagerModuleCreator

	public init(creator: ShowsManagerModuleCreator) {
		self.creator = creator
	}

	public var options: [ShowsManagerOption] {
		let progress = ShowsManagerOption.progress
		let now = ShowsManagerOption.now
		let trending = ShowsManagerOption.trending

		return [progress, now, trending]
	}

	public var modulePages: [ModulePage] {
		let pages = options.map { option -> ModulePage in
			let view = self.creator.createModule(for: option)
			let name = moduleNameFor(option: option)

			return ModulePage(page: view, title: name)
		}

		return pages
	}

	public var defaultModuleIndex: Int {
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
