import RxSwift
import TraktSwift

final class ShowEpisodeService: ShowEpisodeInteractor {
  private let showProgressInteractor: ShowProgressInteractor
  private let repository: ShowEpisodeRepository
  private let imageRepository: ImageRepository

  init(repository: ShowEpisodeRepository,
       showProgressInteractor: ShowProgressInteractor,
       imageRepository: ImageRepository) {
    self.repository = repository
    self.showProgressInteractor = showProgressInteractor
    self.imageRepository = imageRepository
  }

  func fetchImageURL(for episode: EpisodeImageInput) -> Single<URL> {
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)
    return imageRepository.fetchEpisodeImages(for: episode, size: size).asSingle()
  }

  func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])
    let single = episode.lastWatched == nil ?
      repository.addToHistory(items: items) : repository.removeFromHistory(items: items)

    return single.flatMap { [unowned self] _ in
      let showEntityObservable = self.showProgressInteractor.fetchShowProgress(ids: episode.showIds)

      return showEntityObservable.map { SyncResult.success(show: $0.createEntity(using: show.show)) }.asSingle()
      }.catchError { Single.just(SyncResult.fail(error: $0)) }
  }
}
