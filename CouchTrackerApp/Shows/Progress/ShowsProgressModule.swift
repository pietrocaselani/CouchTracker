import CouchTrackerCore

enum ShowsProgressModule {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  static func setupModule() -> BaseView {
    let schedulers = Environment.instance.schedulers
    let traktLoginObservable = Environment.instance.loginObservable
    let userDefaults = Environment.instance.userDefaults
    let imageRepository = Environment.instance.imageRepository

    let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: userDefaults)

    let router = ShowsProgressiOSRouter()
    let cellInteractor = ShowProgressCellService(imageRepository: imageRepository)

    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: Environment.instance.watchedShowEntitiesObservable)

    let presenter = ShowsProgressDefaultPresenter(interactor: interactor,
                                                  router: router,
                                                  loginObservable: traktLoginObservable)

    let viewController = ShowsProgressViewController(presenter: presenter, cellInteractor: cellInteractor)

    router.viewController = viewController

    return viewController
  }
}
