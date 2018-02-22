import UIKit
import CouchTrackerCore

final class TrendingModule {
	private init() {}

	static func setupModule(for trendingType: TrendingType) -> BaseView {
		guard let view = R.storyboard.trending().instantiateInitialViewController() as? TrendingView else {
			fatalError("topViewController should be an instance of TrendingView")
		}

		guard let viewController = view as? UIViewController else {
			fatalError("view should be an instance of UIViewController")
		}

		let traktProvider = Environment.instance.trakt
		let tmdb = Environment.instance.tmdb
		let tvdb = Environment.instance.tvdb
		let schedulers = Environment.instance.schedulers

		let repository = TrendingCacheRepository(traktProvider: traktProvider, schedulers: schedulers)
		let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
		let imageRepository = ImageCachedRepository(tmdb: tmdb,
																								tvdb: tvdb,
																								cofigurationRepository: configurationRepository,
																								schedulers: schedulers)

		let interactor = TrendingService(repository: repository)
		let router = TrendingiOSRouter(viewController: viewController)

		let dataSource = TrendingCollectionViewDataSource(imageRepository: imageRepository)

		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor,
																				router: router, dataSource: dataSource, type: trendingType)

		view.presenter = presenter

		return view
	}
}
