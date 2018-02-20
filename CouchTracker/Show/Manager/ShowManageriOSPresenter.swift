final class ShowManageriOSPresenter: ShowManagerPresenter {
	private weak var view: ShowManagerView?
	private let dataSource: ShowManagerDataSource

	init(view: ShowManagerView, dataSource: ShowManagerDataSource) {
		self.view = view
		self.dataSource = dataSource
	}

	func viewDidLoad() {
		view?.title = dataSource.showTitle
		view?.show(pages: dataSource.modulePages, withDefault: dataSource.defaultModuleIndex)
	}
}
