import CouchTrackerCore

enum ShowsProgressModule {
  static func setupModule() -> BaseView {
    let userDefaults = Environment.instance.userDefaults
    let syncStateObservable = Environment.instance.syncStateObservable
    let imageRepository = Environment.instance.imageRepository
    let appStateManager = Environment.instance.appStateManager
    let watchedShowsObservable = Environment.instance.watchedShowEntitiesObservable

    let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: userDefaults)

    let router = ShowsProgressiOSRouter()
    let cellInteractor = ShowProgressCellService(imageRepository: imageRepository)

    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowsObservable,
                                          syncStateObservable: syncStateObservable,
                                          appConfigsObservable: appStateManager)

    let presenter = ShowsProgressDefaultPresenter(interactor: interactor,
                                                  router: router,
                                                  appConfigsObservable: appStateManager,
                                                  syncStateObservable: syncStateObservable)

    let viewController = ShowsProgressViewController(presenter: presenter, cellInteractor: cellInteractor)

    router.viewController = viewController

    return viewController
  }
}
