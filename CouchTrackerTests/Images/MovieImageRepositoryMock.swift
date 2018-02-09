import RxSwift
import TMDBSwift
import Moya

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
  private let tmdb: TMDBProvider
  private let tvdb: TVDBProvider
  private let configuration: ConfigurationRepository
  var fetchMovieImagesInvoked = false
  var fetchShowImagesInvoked = false
  var fetchEpisodeImagesInvoked = false
  var fetchEpisodeImagesParameters: (EpisodeImageInput, EpisodeImageSizes?)?

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

    guard let tmdbId = episode.tmdb else {
      return Single.never()
    }

    return Single.never()
  }
}
