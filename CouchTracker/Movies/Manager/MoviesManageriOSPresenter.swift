final class MoviesManageriOSPresenter: MoviesManagerPresenter {
	private weak var view: MoviesManagerView?
	private let defaultIndex: Int
	private let modules: [MovieManagerModulePage]

	init(view: MoviesManagerView, dataSource: MoviesManagerDataSource) {
		self.view = view
		self.defaultIndex = dataSource.defaultModuleIndex()
		self.modules = dataSource.modulePages()
	}

	func viewDidLoad() {
		guard let view = self.view else { return }

		view.show(pages: modules, withDefault: defaultIndex)
	}
}
