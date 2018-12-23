import CouchTrackerCore
import UIKit

final class TrendingModule {
  private init() {}

  static func setupModule(for trendingType: TrendingType) -> BaseView {
    guard let view = R.storyboard.trending.instantiateInitialViewController() else {
      fatalError("Could not instantiate view controller from storyboard")
    }

    let traktProvider = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let genreRepository = Environment.instance.genreRepository

    let repository = TrendingCacheRepository(traktProvider: traktProvider, schedulers: schedulers)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

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

    return view
  }
}
