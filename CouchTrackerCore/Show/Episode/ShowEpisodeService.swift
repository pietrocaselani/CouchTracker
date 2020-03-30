import RxSwift
import TraktSwift

public final class ShowEpisodeService: ShowEpisodeInteractor {
  private let repository: ShowEpisodeRepository
  private let imageRepository: ImageRepository

  public init(repository: ShowEpisodeRepository, imageRepository: ImageRepository) {
    self.repository = repository
    self.imageRepository = imageRepository
  }

  public func fetchImages(for episode: EpisodeImageInput) -> Maybe<ShowEpisodeImages> {
    guard let tmdbId = episode.tmdb else { return Maybe.empty() }

    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)
    let episodeURLObservable = imageRepository.fetchEpisodeImages(for: episode, size: size).asObservable()
    let posterImageObservable = fetchShowPosterURL(tmdbId: tmdbId).asObservable()

    return Observable.combineLatest(posterImageObservable, episodeURLObservable) { posterURL, episodeURL in
      ShowEpisodeImages(posterURL: posterURL, previewURL: episodeURL)
    }.asMaybe()
  }

  public func toggleWatch(for episode: WatchedEpisodeEntity) -> Single<WatchedShowEntity> {
    episode.lastWatched == nil ?
      repository.addToHistory(episode: episode.episode) :
      repository.removeFromHistory(episode: episode.episode)
  }

  private func fetchShowPosterURL(tmdbId: Int) -> Maybe<URL> {
    imageRepository.fetchShowImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)
      .flatMap { entity -> Maybe<URL> in
        guard let link = entity.posterImage()?.link, let url = URL(string: link) else {
          return Maybe.empty()
        }

        return Maybe.just(url)
      }
  }
}
