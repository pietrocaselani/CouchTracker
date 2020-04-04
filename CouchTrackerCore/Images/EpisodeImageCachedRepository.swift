import Moya
import RxSwift
import TMDBSwift
import TVDBSwift

public final class EpisodeImageCachedRepository: EpisodeImageRepository {
  typealias TMDBEpisodes = TMDBSwift.Episodes
  typealias TVDBEpisodes = TVDBSwift.Episodes

  private let configurationRepository: ConfigurationRepository
  private let tmdb: TMDBProvider
  private let tvdb: TVDBProvider
  private var cache: [Int: URL]

  public init(tmdb: TMDBProvider,
              tvdb: TVDBProvider,
              configurationRepository: ConfigurationRepository,
              cache: [Int: URL] = [Int: URL]()) {
    self.configurationRepository = configurationRepository
    self.tmdb = tmdb
    self.tvdb = tvdb
    self.cache = cache
  }

  public func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes? = nil) -> Maybe<URL> {
    let cacheKey = EpisodeImageUtils.cacheKey(episode: episode, size: size)

    guard let imageURL = cache[cacheKey] else {
      return fetchImageFromAPIs(episode: episode, size: size)
        .do(onNext: { [weak self] url in
          self?.cache[cacheKey] = url
        })
    }

    return Maybe.just(imageURL)
  }

  private func fetchImageFromAPIs(episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
    guard let tvdbId = episode.tvdb else {
      guard let tmdbId = episode.tmdb else {
        return Maybe.empty()
      }

      return tmdbObservable(tmdbId, episode.season, episode.number, size?.tmdb ?? .w300)
    }

    let tvdbObservable = fetchEpisodeImageFromTVDB(tvdbId, size?.tvdb ?? .normal)

    guard let tmdbId = episode.tmdb else {
      return tvdbObservable
    }

    return tmdbObservable(tmdbId, episode.season, episode.number, size?.tmdb ?? .w300)
      .catchError { _ in tvdbObservable }
      .ifEmpty(switchTo: tvdbObservable)
  }

  private func tmdbObservable(_ showId: Int, _ season: Int,
                              _ number: Int, _ size: StillImageSize) -> Maybe<URL> {
    fetchEpisodeImageFromTMDB(showId, season, number, size)
  }

  private func fetchEpisodeImageFromTMDB(_ showId: Int, _ season: Int,
                                         _ number: Int, _ size: StillImageSize) -> Maybe<URL> {
    let target = TMDBEpisodes.images(showId: showId, season: season, episode: number)

    let apiObservable = TMDBImageUtils.imagesFromAPI(using: tmdb.episodes, with: target)
    let maybe = TMDBImageUtils.createImagesEntities(configurationRepository, apiObservable, stillSize: size).asMaybe()

    return maybe.flatMap { entity -> Maybe<URL> in
      guard let link = entity.stillImage()?.link, let url = URL(string: link) else {
        return Maybe.empty()
      }
      return Maybe.just(url)
    }
  }

  private func fetchEpisodeImageFromTVDB(_ tvdbId: Int, _ size: TVDBEpisodeImageSize) -> Maybe<URL> {
    let target = TVDBEpisodes.episode(id: tvdbId)

    let api = tvdb.episodes.rx.request(target).filterSuccessfulStatusAndRedirectCodes().map(EpisodeResponse.self)

    return api.flatMapMaybe { episodeResponse -> Maybe<URL> in
      guard let filename = episodeResponse.episode.filename else { return Maybe.empty() }
      let url = EpisodeImageUtils.tvdbBaseURLFor(size: size).appendingPathComponent(filename)
      return Maybe.just(url)
    }
  }
}
