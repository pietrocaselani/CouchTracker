import CouchTrackerCore

enum ShowsProgressModule {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  static func setupModule() -> BaseView {
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let traktLoginObservable = Environment.instance.loginObservable
    let userDefaults = Environment.instance.userDefaults
    let syncStateObservable = Environment.instance.syncStateObservable

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: userDefaults)

    let router = ShowsProgressiOSRouter()
    let cellInteractor = ShowProgressCellService(imageRepository: imageRepository)

    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: Environment.instance.watchedShowEntitiesObservable)

    let presenter = ShowsProgressDefaultPresenter(interactor: interactor,
                                                  router: router,
                                                  loginObservable: traktLoginObservable,
                                                  syncStateObservable: syncStateObservable)

    let viewController = ShowsProgressViewController(presenter: presenter, cellInteractor: cellInteractor)

    router.viewController = viewController

    return viewController
  }
}
