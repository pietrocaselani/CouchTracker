import RxSwift

public protocol AppFlowModuleDataSource: class {
  var modulePages: [ModulePage] { get }
}

public protocol AppFlowPresenter: class {
  init(repository: AppFlowRepository, moduleDataSource: AppFlowModuleDataSource)

  func observeViewState() -> Observable<AppFlowViewState>
  func viewDidLoad()
  func selectTab(index: Int)
}

public protocol AppFlowRepository: class {
  var lastSelectedTab: Int { get set }
}
