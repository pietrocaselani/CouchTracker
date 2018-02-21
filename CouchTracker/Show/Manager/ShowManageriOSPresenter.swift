public final class ShowManageriOSPresenter: ShowManagerPresenter {
	private weak var view: ShowManagerView?
	private let dataSource: ShowManagerDataSource

	public init(view: ShowManagerView, dataSource: ShowManagerDataSource) {
		self.view = view
		self.dataSource = dataSource
	}

	public func viewDidLoad() {
		view?.title = dataSource.showTitle
		view?.show(pages: dataSource.modulePages, withDefault: dataSource.defaultModuleIndex)
	}
}
