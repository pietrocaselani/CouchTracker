import RxSwift

public protocol AppFlowModuleDataSource: AnyObject {
  var modulePages: [ModulePage] { get }
}

public protocol AppFlowPresenter: AnyObject {
  init(repository: AppFlowRepository, moduleDataSource: AppFlowModuleDataSource)

  func observeViewState() -> Observable<AppFlowViewState>
  func viewDidLoad()
  func selectTab(index: Int)
}

public protocol AppFlowRepository: AnyObject {
  var lastSelectedTab: Int { get set }
}
