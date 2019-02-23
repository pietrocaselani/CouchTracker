import CouchTrackerCore

enum AppStateModule {
  static func setupModule() -> BaseView {
    let appStateManager = Environment.instance.appStateManager

    let router = AppStateiOSRouter()
    let presenter = AppStateDefaultPresenter(router: router, appStateManager: appStateManager)

    let viewController = AppStateViewController(presenter: presenter)

    router.viewController = viewController

    return UINavigationController(rootViewController: viewController)
  }
}
