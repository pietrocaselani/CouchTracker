import CouchTrackerCore
import TraktSwift

final class SearchModule {
  private init() {}

  static func setupModule(searchTypes: [SearchType]) -> BaseView {
    let environment = Environment.instance
    let tmdb = environment.tmdb
    let tvdb = environment.tvdb
    let schedulers = environment.schedulers
    let trakt = environment.trakt

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)

    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let posterCellInteractor = PosterCellService(imageRepository: imageRepository)

    let dataSource = SearchCollectionViewDataSource(interactor: posterCellInteractor)

    let interactor = SearchService(traktProvider: trakt)

    let presenter = SearchDefaultPresenter(interactor: interactor, types: searchTypes)

    return SearchViewController(presenter: presenter, dataSource: dataSource)
  }
}
