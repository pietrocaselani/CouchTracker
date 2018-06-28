import TraktSwift
import CouchTrackerCore

final class MovieDetailsModule {
	private init() {}

	static func setupModule(movieIds: MovieIds) -> BaseView {
		let trakt = Environment.instance.trakt
		let tmdb = Environment.instance.tmdb
		let tvdb = Environment.instance.tvdb
		let schedulers = Environment.instance.schedulers

		let repository = MovieDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)
		let genreRepository = TraktGenreRepository(traktProvider: trakt, schedulers: schedulers)
		let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
		let imageRespository = ImageCachedRepository(tmdb: tmdb,
																								tvdb: tvdb,
																								cofigurationRepository: configurationRepository,
																								schedulers: schedulers)

		let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
																				imageRepository: imageRespository, movieIds: movieIds)

		let viewController = R.storyboard.movieDetails.movieDetailsViewController()

		guard let view = viewController else {
			Swift.fatalError("viewController should be an instance of MovieDetailsView")
		}

		let presenter = MovieDetailsDefaultPresenter(interactor: interactor)

		view.presenter = presenter

		return view
	}
}
