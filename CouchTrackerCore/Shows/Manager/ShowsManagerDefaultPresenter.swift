import RxSwift

public final class ShowsManagerDefaultPresenter: ShowsManagerPresenter {
    private weak var view: ShowsManagerView?
    private let disposeBag = DisposeBag()
    private let dataSource: ShowsManagerDataSource

    public init(view: ShowsManagerView, moduleSetup: ShowsManagerDataSource) {
        self.view = view
        dataSource = moduleSetup
    }

    public func viewDidLoad() {
        let pages = dataSource.modulePages
        let defaultIndex = dataSource.defaultModuleIndex

        view?.show(pages: pages, withDefault: defaultIndex)
    }

    public func selectTab(index: Int) {
        dataSource.defaultModuleIndex = index
    }
}
