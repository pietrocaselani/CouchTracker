import RxSwift
import TraktSwift

final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository
  private let showProgressInteractor: ShowProgressInteractor

  init(repository: ShowsProgressRepository, showProgressInteractor: ShowProgressInteractor) {
    self.repository = repository
    self.showProgressInteractor = showProgressInteractor
  }

  func fetchWatchedShowsProgress(update: Bool) -> Observable<WatchedShowEntity> {
    return repository.fetchWatchedShows(update: update, extended: .full)
      .flatMap { Observable.from($0) }
      .flatMap { [unowned self] in self.fetchShowProgress(update, $0) }
  }

  private func fetchShowProgress(_ update: Bool, _ baseShow: BaseShow) -> Observable<WatchedShowEntity> {
    guard let show = baseShow.show else { return Observable.empty() }

    return showProgressInteractor.fetchShowProgress(update: update, ids: show.ids)
      .flatMap { [unowned self] in return self.mapToEntity(baseShow, builder: $0) }
  }

  private func mapToEntity(_ baseShow: BaseShow, builder: WatchedShowBuilder) -> Observable<WatchedShowEntity> {
    guard let show = baseShow.show else { return Observable.empty() }

    let showIds = builder.ids

    let showEntity = ShowEntityMapper.entity(for: show)
    let episodeEntity = builder.episode.map { EpisodeEntityMapper.entity(for: $0, showIds: showIds) }

    let aired = builder.detailShow?.aired ?? 0
    let completed = builder.detailShow?.completed ?? 0

    let lastWatched = builder.detailShow?.lastWatchedAt

    let entity = WatchedShowEntity(show: showEntity,
                                   aired: aired,
                                   completed: completed,
                                   nextEpisode: episodeEntity,
                                   lastWatched: lastWatched)
    return Observable.just(entity)
  }
}
