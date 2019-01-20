import CouchTrackerCore

final class TrendingModule {
  private init() {}

  static func setupModule(for trendingType: TrendingType) -> BaseView {
    let traktProvider = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let genreRepository = Environment.instance.genreRepository

    let repository = TrendingCacheRepository(traktProvider: traktProvider, schedulers: schedulers)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                configurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let view = TrendingViewController()

    let interactor = TrendingService(repository: repository, genreRepository: genreRepository)
    let router = TrendingiOSRouter(viewController: view)

    let dataSource = TrendingCollectionViewDataSource(imageRepository: imageRepository)

    let presenter = TrendingDefaultPresenter(view: view,
                                             interactor: interactor,
                                             router: router,
                                             dataSource: dataSource,
                                             type: trendingType,
                                             schedulers: schedulers)

    view.presenter = presenter
    view.trendingType = trendingType

    return view
  }
}
