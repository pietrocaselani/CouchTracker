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
  private var cache = [Int: URL]()

  public init(tmdb: TMDBProvider,
              tvdb: TVDBProvider,
              configurationRepository: ConfigurationRepository) {
    self.configurationRepository = configurationRepository
    self.tmdb = tmdb
    self.tvdb = tvdb
  }

  public func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes? = nil) -> Maybe<URL> {
    let cacheKey = EpisodeImageCachedRepository.cacheKey(episode: episode, size: size)

    guard let imageURL = cache[cacheKey] else {
      return fetchImageFromAPIs(episode: episode, size: size).do(onNext: { [weak self] url in
        self?.cache[cacheKey] = url
      })
    }

    return Maybe.just(imageURL)
  }

  private func fetchImageFromAPIs(episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
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
      let url = EpisodeImageCachedRepository.tvdbBaseURLFor(size: size).appendingPathComponent(filename)
      return Maybe.just(url)
    }
  }

  private static func tvdbBaseURLFor(size: TVDBEpisodeImageSize?) -> URL {
    return (size ?? .normal) == .normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
  }

  private static func cacheKey(episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Int {
    var hasher = Hasher()
    hasher.combine(HashableEpisodeImageInput(episode))
    size.run { hasher.combine($0) }
    return hasher.finalize()
  }
}
