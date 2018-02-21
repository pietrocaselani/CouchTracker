import RxSwift
import TMDBSwift
import TVDBSwift
import Moya
@testable import CouchTrackerCore

func createMovieImagesRepositoryMock(_ images: ImagesEntity) -> ImageRepository {
	return ImagesRepositorySampleMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock, images: images)
}

final class EmptyImageRepositoryMock: ImageRepository {
	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		return Single.never()
	}

	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		return Single.never()
	}

	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Single<URL> {
		return Single.never()
	}
}

final class ImagesRepositorySampleMock: ImageRepository {
	private let images: ImagesEntity

	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
		let imageEntities = [ImageEntity(link: "", width: 10, height: 10, iso6391: nil, aspectRatio: 1.2, voteAverage: 2.3, voteCount: 5)]
		self.images = ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: [ImageEntity]())
	}

	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository, images: ImagesEntity) {
		self.images = images
	}

	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		return Single.just(images)
	}

	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		return Single.just(images)
	}

	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Single<URL> {
		return Single.never()
	}
}

final class ImageRepositoryMock: ImageRepository {
	typealias TMDBEpisodes = TMDBSwift.Episodes
	typealias TVDBEpisodes = TVDBSwift.Episodes

	private let tmdb: TMDBProvider
	private let tvdb: TVDBProvider
	private let configuration: ConfigurationRepository
	var fetchMovieImagesInvoked = false
	var fetchShowImagesInvoked = false
	var fetchEpisodeImagesInvoked = false
	var fetchEpisodeImagesParameters: (input: EpisodeImageInput, sizes: EpisodeImageSizes?)?

	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
		self.tmdb = tmdb
		self.tvdb = tvdb
		self.configuration = cofigurationRepository
	}

	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		fetchMovieImagesInvoked = true
		let observable = configuration.fetchConfiguration().asObservable().flatMap { [unowned self] config -> Observable<ImagesEntity> in
			return self.tmdb.movies.rx.request(.images(movieId: movieId)).asObservable().map(Images.self).map {
				let posterSize = posterSize ?? .w342
				let backdropSize = backdropSize ?? .w300

				return ImagesEntityMapper.entity(for: $0, using: config, posterSize: posterSize, backdropSize: backdropSize)
			}
		}

		return observable.asSingle()
	}

	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
		fetchShowImagesInvoked = true
		let configurationObservable = configuration.fetchConfiguration()
		let imagesObservable = tmdb.shows.rx.request(.images(showId: showId)).map(Images.self).asObservable()

		return Observable.combineLatest(imagesObservable, configurationObservable) { images, configuration -> ImagesEntity in
			let posterSize = posterSize ?? .w342
			let backdropSize = backdropSize ?? .w300
			return ImagesEntityMapper.entity(for: images, using: configuration, posterSize: posterSize, backdropSize: backdropSize)
		}.asSingle()
	}

	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Single<URL> {
		fetchEpisodeImagesInvoked = true
		fetchEpisodeImagesParameters = (episode, size)

		let tmdbObservable = fetchEpisodeImageFromTMDB(episode, size)
		let tvdbObservable = fetchEpisodeImageFromTVDB(episode, size)

		return tmdbObservable.ifEmpty(switchTo: tvdbObservable).catchError { _ in tvdbObservable }.asSingle()
	}

	private func fetchEpisodeImageFromTVDB(_ episode: EpisodeImageInput, _ size: EpisodeImageSizes?) -> Observable<URL> {
		let single = tvdb.episodes.rx.request(TVDBEpisodes.episode(id: episode.tvdb)).map(EpisodeResponse.self)

		return single.asObservable().flatMap { response -> Observable<URL> in
			guard let filename = response.episode.filename else { return Observable.empty() }

			let size = size?.tvdb ?? TVDBEpisodeImageSize.normal
			let baseURL = size == TVDBEpisodeImageSize.normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
			return Observable.just(baseURL.appendingPathComponent(filename))
		}
	}

	private func fetchEpisodeImageFromTMDB(_ episode: EpisodeImageInput, _ size: EpisodeImageSizes?) -> Observable<URL> {
		guard let tmdbId = episode.tmdb else {
			return Observable.empty()
		}

		let target = TMDBEpisodes.images(showId: tmdbId, season: episode.season, episode: episode.number)
		let tmdbImages = tmdb.episodes.rx.request(target).map(Images.self).asObservable()
		let configurationObservable = configuration.fetchConfiguration()

		let imagesObservable = Observable.combineLatest(tmdbImages, configurationObservable) { (images, configuration) -> ImagesEntity in
			let tmdbSize = size?.tmdb ?? StillImageSize.w300
			return ImagesEntityMapper.entity(for: images, using: configuration, stillSize: tmdbSize)
		}

		let tmdbURLObservable = imagesObservable.flatMap { images -> Observable<URL> in
			guard let link = images.stillImage()?.link, let url = URL(string: link) else { return Observable.empty() }
			return Observable.just(url)
		}

		return tmdbURLObservable
	}
}
