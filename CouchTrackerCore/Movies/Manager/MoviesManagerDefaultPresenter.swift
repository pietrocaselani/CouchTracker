public final class MoviesManagerDefaultPresenter: MoviesManagerPresenter {
    private weak var view: MoviesManagerView?
    private let defaultIndex: Int
    private let modules: [ModulePage]

    public init(view: MoviesManagerView, dataSource: MoviesManagerDataSource) {
        self.view = view
        defaultIndex = dataSource.defaultModuleIndex
        modules = dataSource.modulePages
    }

    public func viewDidLoad() {
        view?.show(pages: modules, withDefault: defaultIndex)
    }
}
