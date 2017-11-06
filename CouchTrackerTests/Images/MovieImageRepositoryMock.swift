import RxSwift
import TMDBSwift
import Moya

final class EmptyImageRepositoryMock: ImageRepository {
  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.empty()
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.never()
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
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

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.just(images)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.just(images)
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}


final class ImageRepositoryMock: ImageRepository {
  private let provider: TMDBProvider
  private let configuration: ConfigurationRepository

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.provider = tmdb
    self.configuration = cofigurationRepository
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let observable = configuration.fetchConfiguration().asObservable().flatMap { [unowned self] config -> Observable<ImagesEntity> in
      return self.provider.movies.rx.request(.images(movieId: movieId)).asObservable().map(Images.self).map {
        let posterSize = posterSize ?? .w342
        let backdropSize = backdropSize ?? .w300

        return ImagesEntityMapper.entity(for: $0, using: config, posterSize: posterSize, backdropSize: backdropSize)
      }
    }

    return observable
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    let configurationObservable = configuration.fetchConfiguration()
    let imagesObservable = provider.shows.rx.request(.images(showId: showId)).map(Images.self).asObservable()

    return Observable.combineLatest(imagesObservable, configurationObservable) { images, configuration -> ImagesEntity in
      let posterSize = posterSize ?? .w342
      let backdropSize = backdropSize ?? .w300
      return ImagesEntityMapper.entity(for: images, using: configuration, posterSize: posterSize, backdropSize: backdropSize)
    }.asSingle()
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}
