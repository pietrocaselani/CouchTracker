import CouchTrackerCore

public protocol ShowsProgressViewDataSource: UITableViewDataSource {
  var viewModels: [WatchedShowViewModel] { get set }
}

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

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: userDefaults)

    let router = ShowsProgressiOSRouter()
    let cellInteractor = ShowProgressCellService(imageRepository: imageRepository)
    let viewDataSource = ShowsProgressTableViewDataSource(interactor: cellInteractor)

    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: Environment.instance.watchedShowEntitiesObservable)

    let presenter = ShowsProgressDefaultPresenter(interactor: interactor,
                                                  router: router,
                                                  loginObservable: traktLoginObservable)

    let viewController = ShowsProgressViewController(presenter: presenter, dataSource: viewDataSource)

    router.viewController = viewController

    return viewController
  }
}
