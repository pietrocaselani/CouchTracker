public protocol AppFlowView: class {
    var presenter: AppFlowPresenter! { get set }

    func show(pages: [ModulePage], selectedIndex: Int)
}

public protocol AppFlowModuleDataSource: class {
    var modulePages: [ModulePage] { get }
}

public protocol AppFlowPresenter: class {
    init(view: AppFlowView, interactor: AppFlowInteractor, moduleDataSource: AppFlowModuleDataSource)

    func viewDidLoad()
    func selectTab(index: Int)
}

public protocol AppFlowRepository: class {
    var lastSelectedTab: Int { get set }
}

public protocol AppFlowInteractor: class {
    var lastSelectedTab: Int { get set }
}
