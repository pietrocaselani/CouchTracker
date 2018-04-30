import Foundation

public final class MoviesManagerDefaultDataSource: MoviesManagerDataSource {
	private static let moviesManagerLastTab = "moviesManagerLastTab"
	private let creator: MoviesManagerModuleCreator
	private let userDefaults: UserDefaults

	public var options: [MoviesManagerOption]

	public var modulePages: [ModulePage] {
		return options.map { option -> ModulePage in
			let view = creator.createModule(for: option)
			let title = moduleNameFor(option: option)

			return ModulePage(page: view, title: title)
		}
	}
	public var defaultModuleIndex: Int {
		get {
			return userDefaults.integer(forKey: MoviesManagerDefaultDataSource.moviesManagerLastTab)
		}
		set {
			userDefaults.set(newValue, forKey: MoviesManagerDefaultDataSource.moviesManagerLastTab)
		}
	}

	public init(creator: MoviesManagerModuleCreator) {
		Swift.fatalError("Please, use init(creator: userDefaults:)")
	}

	public init(creator: MoviesManagerModuleCreator, userDefaults: UserDefaults) {
		self.creator = creator
		self.userDefaults = userDefaults

		self.options = [.trending, .search]
	}

	private func moduleNameFor(option: MoviesManagerOption) -> String {
		switch option {
		case .trending:
			return "Trending".localized
		case .search:
			return "Search".localized
		}
	}
}
