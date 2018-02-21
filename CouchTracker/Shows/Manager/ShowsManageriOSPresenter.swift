import RxSwift

public final class ShowsManageriOSPresenter: ShowsManagerPresenter {
	private weak var view: ShowsManagerView?
	private let disposeBag = DisposeBag()
	private let defaultIndex: Int
	private let pages: [ModulePage]

	public init(view: ShowsManagerView, moduleSetup: ShowsManagerDataSource) {
		self.view = view
		self.pages = moduleSetup.modulePages
		self.defaultIndex = moduleSetup.defaultModuleIndex
	}

	public func viewDidLoad() {
		view?.show(pages: pages, withDefault: self.defaultIndex)
	}
}
