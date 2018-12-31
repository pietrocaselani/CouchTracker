import CouchTrackerCore

final class ShowsProgressModule {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsProgress.showsProgressViewController() else {
      Swift.fatalError("Can't instantiate showsProgressController from Shows storyboard")
    }

    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let traktLoginObservable = Environment.instance.loginObservable

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: UserDefaults.standard)

    let router = ShowsProgressiOSRouter(viewController: view)
    let viewDataSource = ShowsProgressTableViewDataSource(imageRepository: imageRepository)

    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: Environment.instance.watchedShowEntitiesObservable)

    let presenter = ShowsProgressDefaultPresenter(view: view,
                                                  interactor: interactor,
                                                  viewDataSource: viewDataSource,
                                                  router: router,
                                                  loginObservable: traktLoginObservable)

    view.presenter = presenter

    return view
  }
}
