import CouchTrackerCore

enum AppStateModule {
  static func setupModule() -> BaseView {
    let appStateManager = Environment.instance.appStateManager

    let interactor = AppStateService(appStateManager: appStateManager)
    let router = AppStateiOSRouter()
    let presenter = AppStateDefaultPresenter(interactor: interactor,
                                             router: router,
                                             appStateObservable: appStateManager)

    let viewController = AppStateViewController(presenter: presenter)

    router.viewController = viewController

    return UINavigationController(rootViewController: viewController)
  }
}
