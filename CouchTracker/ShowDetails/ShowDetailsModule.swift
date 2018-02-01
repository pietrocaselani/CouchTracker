import TraktSwift

final class ShowDetailsModule {
  private init() {}

  static func setupModule(showIds: ShowIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers

    let repository = ShowDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)
    let genreRepository = TraktGenreRepository(traktProvider: trakt, schedulers: schedulers)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let interactor = ShowDetailsService(showIds: showIds, repository: repository,
                                        genreRepository: genreRepository, imageRepository: imageRepository)

    guard let view = R.storyboard.showDetails.showDetailsViewController() else {
      Swift.fatalError("view should be an instance of ShowDetailsViewController")
    }

    let router = ShowDetailsiOSRouter(viewController: view)

    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    view.presenter = presenter

    return view
  }
}
