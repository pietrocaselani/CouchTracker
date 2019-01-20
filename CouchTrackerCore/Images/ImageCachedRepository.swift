import Moya
import RxSwift
import TMDBSwift
import TVDBSwift

public final class ImageCachedRepository: ImageRepository {
  typealias TMDBEpisodes = TMDBSwift.Episodes
  typealias TVDBEpisodes = TVDBSwift.Episodes

  private let configurationRepository: ConfigurationRepository
  private let tmdb: TMDBProvider
  private let tvdb: TVDBProvider
  private let schedulers: Schedulers

  public init(tmdb: TMDBProvider,
              tvdb: TVDBProvider,
              configurationRepository: ConfigurationRepository,
              schedulers: Schedulers) {
    self.configurationRepository = configurationRepository
    self.tmdb = tmdb
    self.tvdb = tvdb
    self.schedulers = schedulers
  }

  public func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                               backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    let target = Movies.images(movieId: movieId)
    let apiObservable = imagesFromAPI(using: tmdb.movies, with: target)
    return createImagesEntities(apiObservable, posterSize: posterSize, backdropSize: backdropSize)
  }

  public func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                              backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    let target = Shows.images(showId: showId)
    let apiObservable = imagesFromAPI(using: tmdb.shows, with: target)
    return createImagesEntities(apiObservable, posterSize: posterSize, backdropSize: backdropSize)
  }

  public func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes? = nil) -> Maybe<URL> {
    guard let tvdbId = episode.tvdb else {
      return Maybe.empty()
    }

    let tvdbObservable = fetchEpisodeImageFromTVDB(tvdbId, size?.tvdb ?? .normal)

    guard let tmdbId = episode.tmdb else {
      return tvdbObservable
    }

    return fetchEpisodeImageFromTMDB(tmdbId, episode.season, episode.number, size?.tmdb ?? .w300)
      .catchError { _ in tvdbObservable }
      .ifEmpty(switchTo: tvdbObservable)
  }

  private func fetchEpisodeImageFromTMDB(_ showId: Int, _ season: Int,
                                         _ number: Int, _ size: StillImageSize) -> Maybe<URL> {
    let target = TMDBEpisodes.images(showId: showId, season: season, episode: number)

    let apiObservable = imagesFromAPI(using: tmdb.episodes, with: target)

    let maybe = createImagesEntities(apiObservable,
                                     posterSize: nil,
                                     backdropSize: nil,
                                     stillSize: size)

    return maybe.flatMap { entity -> Maybe<URL> in
      guard let link = entity.stillImage()?.link, let url = URL(string: link) else {
        return Maybe.empty()
      }
      return Maybe.just(url)
    }
  }

  private func fetchEpisodeImageFromTVDB(_ tvdbId: Int, _ size: TVDBEpisodeImageSize) -> Maybe<URL> {
    let target = TVDBEpisodes.episode(id: tvdbId)

    let api = tvdb.episodes.rx.request(target).map(EpisodeResponse.self)

    return api.flatMapMaybe { [unowned self] episodeResponse -> Maybe<URL> in
      guard let filename = episodeResponse.episode.filename else { return Maybe.empty() }
      let url = self.tvdbBaseURLFor(size: size).appendingPathComponent(filename)
      return Maybe.just(url)
    }
  }

  private func tvdbBaseURLFor(size: TVDBEpisodeImageSize?) -> URL {
    return (size ?? .normal) == .normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
  }

  private func createImagesEntities(_ imagesObservable: Observable<Images>, posterSize: PosterImageSize? = nil,
                                    backdropSize: BackdropImageSize? = nil,
                                    stillSize: StillImageSize? = nil) -> Maybe<ImagesEntity> {
    let configurationObservable = configurationRepository.fetchConfiguration()

    let observable = Observable.combineLatest(imagesObservable, configurationObservable) {
      return ImagesEntityMapper.entity(for: $0, using: $1,
                                       posterSize: posterSize ?? .w342,
                                       backdropSize: backdropSize ?? .w300,
                                       stillSize: stillSize ?? .w300)
    }

    return observable.observeOn(schedulers.networkScheduler).asMaybe()
  }

  private func imagesFromAPI<T: TMDBType>(using provider: MoyaProvider<T>, with target: T) -> Observable<Images> {
    return provider.rx.request(target).map(Images.self).asObservable()
  }
}
