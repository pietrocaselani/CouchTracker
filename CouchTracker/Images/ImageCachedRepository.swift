import Moya
import RxSwift
import TMDBSwift
import TVDBSwift

final class ImageCachedRepository: ImageRepository {
	typealias TMDBEpisodes = TMDBSwift.Episodes
	typealias TVDBEpisodes = TVDBSwift.Episodes

	private let configurationRepository: ConfigurationRepository
	private let cache: AnyCache<Int, NSData>
	private let tmdb: TMDBProvider
	private let tvdb: TVDBProvider

	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
		fatalError("Please, use init(tmdb: tvdb: configurationRepository: cache:)")
	}

	init(tmdb: TMDBProvider, tvdb: TVDBProvider,
			 cofigurationRepository: ConfigurationRepository, cache: AnyCache<Int, NSData>) {
		self.configurationRepository = cofigurationRepository
		self.tmdb = tmdb
		self.tvdb = tvdb
		self.cache = cache
	}

	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
												backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
		let target = Movies.images(movieId: movieId)

		let apiObservable = imagesFromAPI(using: tmdb.movies, with: target)

		return createImagesEntities(apiObservable, posterSize: posterSize, backdropSize: backdropSize)
	}

	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
											 backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		let target = Shows.images(showId: showId)

		let apiObservable = imagesFromAPI(using: tmdb.shows, with: target)

		return createImagesEntities(apiObservable, posterSize: posterSize, backdropSize: backdropSize).asSingle()
	}

	func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
		let tvdbObservable = fetchEpisodeImageFromTVDB(episode.ids.tvdb, size?.tvdb ?? .normal)

		guard let tmdbId = episode.showIds.tmdb else {
			return tvdbObservable
		}

		return fetchEpisodeImageFromTMDB(tmdbId, episode.season, episode.number, size?.tmdb ?? .w300)
			.catchError { _ in tvdbObservable }
			.ifEmpty(switchTo: tvdbObservable)
	}

	private func fetchEpisodeImageFromTMDB(_ showId: Int, _ season: Int,
																				 _ number: Int, _ size: StillImageSize) -> Observable<URL> {
		let target = TMDBEpisodes.images(showId: showId, season: season, episode: number)

		let apiObservable = imagesFromAPI(using: tmdb.episodes, with: target)

		let observable = createImagesEntities(apiObservable,
																					posterSize: nil,
																					backdropSize: nil,
																					stillSize: size)

		return observable.flatMap { entity -> Observable<URL> in
			guard let link = entity.stillImage()?.link, let url = URL(string: link) else {
				return Observable.empty()
			}
			return Observable.just(url)
		}
	}

	private func fetchEpisodeImageFromTVDB(_ tvdbId: Int, _ size: TVDBEpisodeImageSize) -> Observable<URL> {
		let target = TVDBEpisodes.episode(id: tvdbId)

		let api = tvdb.episodes.rx.request(target)

		return api
			.map(EpisodeResponse.self)
			.asObservable()
			.flatMap { [unowned self] episodeResponse -> Observable<URL> in
				guard let filename = episodeResponse.episode.filename else { return Observable.empty() }
				let url = self.tvdbBaseURLFor(size: size).appendingPathComponent(filename)
				return Observable.just(url)
		}
	}

	private func tvdbBaseURLFor(size: TVDBEpisodeImageSize?) -> URL {
		return (size ?? .normal) == .normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
	}

	private func createImagesObservable(_ cacheObservable: Observable<Images>,
																			_ apiObservable: Observable<Images>) -> Observable<Images> {
		return cacheObservable.catchError { _ in apiObservable }.ifEmpty(switchTo: apiObservable)
	}

	private func createImagesEntities(_ imagesObservable: Observable<Images>, posterSize: PosterImageSize? = nil,
																		backdropSize: BackdropImageSize? = nil,
																		stillSize: StillImageSize? = nil) -> Observable<ImagesEntity> {
		let configurationObservable = configurationRepository.fetchConfiguration()

		let observable = Observable.combineLatest(imagesObservable, configurationObservable) {
			return ImagesEntityMapper.entity(for: $0, using: $1,
																			 posterSize: posterSize ?? .w342,
																			 backdropSize: backdropSize ?? .w300,
																			 stillSize: stillSize ?? .w300)
		}

		let scheduler = SerialDispatchQueueScheduler(qos: .background)

		return observable.subscribeOn(scheduler).observeOn(scheduler)
	}

	private func imagesFromAPI<T: TMDBType>(using provider: MoyaProvider<T>, with target: T) -> Observable<Images> {
		return provider.rx.request(target).map(Images.self).asObservable()
	}
}
