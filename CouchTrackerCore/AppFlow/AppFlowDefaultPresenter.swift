public final class AppFlowDefaultPresenter: AppFlowPresenter {
    private weak var view: AppFlowView?
    private let interactor: AppFlowInteractor
    private let dataSource: AppFlowModuleDataSource

    public init(view: AppFlowView, interactor: AppFlowInteractor, moduleDataSource: AppFlowModuleDataSource) {
        self.view = view
        self.interactor = interactor
        dataSource = moduleDataSource
    }

    public func viewDidLoad() {
        guard let view = view else {
            return
        }

        let selectedIndex = interactor.lastSelectedTab
        let pages = dataSource.modulePages

        view.show(pages: pages, selectedIndex: selectedIndex)
    }

    public func selectTab(index: Int) {
        interactor.lastSelectedTab = index
    }
}
