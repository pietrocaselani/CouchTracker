import CouchTrackerCore
import TraktSwift

final class ShowOverviewModule {
  private init() {}

  static func setupModule(showIds: ShowIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let genreRepository = Environment.instance.genreRepository

    let repository = ShowOverviewAPIRepository(traktProvider: trakt, schedulers: schedulers)

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                configurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let interactor = ShowOverviewService(showIds: showIds, repository: repository,
                                         genreRepository: genreRepository, imageRepository: imageRepository)

    let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

    return ShowOverviewViewController(presenter: presenter)
  }
}
