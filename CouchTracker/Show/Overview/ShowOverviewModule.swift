import CouchTrackerCore
import TraktSwift

final class ShowOverviewModule {
    private init() {}

    static func setupModule(showIds: ShowIds) -> BaseView {
        let trakt = Environment.instance.trakt
        let tmdb = Environment.instance.tmdb
        let tvdb = Environment.instance.tvdb
        let schedulers = Environment.instance.schedulers

        let repository = ShowOverviewAPIRepository(traktProvider: trakt, schedulers: schedulers)
        let genreRepository = TraktGenreRepository(traktProvider: trakt, schedulers: schedulers)
        let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
        let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                    tvdb: tvdb,
                                                    cofigurationRepository: configurationRepository,
                                                    schedulers: schedulers)

        let interactor = ShowOverviewService(showIds: showIds, repository: repository,
                                             genreRepository: genreRepository, imageRepository: imageRepository)

        guard let view = R.storyboard.showOverview.showOverviewViewController() else {
            Swift.fatalError("view should be an instance of ShowOverviewViewController")
        }

        let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

        view.presenter = presenter

        return view
    }
}
