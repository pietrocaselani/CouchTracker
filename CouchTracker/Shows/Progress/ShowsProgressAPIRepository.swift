import TraktSwift
import RxSwift
import Moya

final class ShowsProgressAPIRepository: ShowsProgressRepository {
  private let trakt: TraktProvider
  private let dataSource: ShowsProgressDataSource
  private let schedulers: Schedulers
  private let showProgressRepository: ShowProgressRepository
  private let disposeBag = DisposeBag()

  init(trakt: TraktProvider, dataSource: ShowsProgressDataSource,
       schedulers: Schedulers, showProgressRepository: ShowProgressRepository) {
    self.trakt = trakt
    self.dataSource = dataSource
    self.schedulers = schedulers
    self.showProgressRepository = showProgressRepository
  }

  func fetchWatchedShows(extended: Extended) -> Observable<[WatchedShowEntity]> {
    fetchWatchedShowsFromAPI(extended: extended)
      .observeOn(schedulers.dataSourceScheduler)
      .do(onNext: { [unowned self] entities in
        try self.dataSource.addWatched(shows: entities)
      })
      .subscribe()
      .disposed(by: disposeBag)

    return fetchWatchedShowsFromDataSource().subscribeOn(schedulers.dataSourceScheduler)
  }

  private func fetchWatchedShowsFromAPI(extended: Extended) -> Observable<[WatchedShowEntity]> {
    let api = trakt.sync.rx.request(Sync.watched(type: .shows, extended: extended)).map([BaseShow].self).asObservable()

    return api.observeOn(schedulers.networkScheduler)
      .flatMap { Observable.from($0) }
      .flatMap { [unowned self] in self.fetchShowProgress($0) }
      .toArray()
  }

  private func fetchWatchedShowsFromDataSource() -> Observable<[WatchedShowEntity]> {
    return dataSource.fetchWatchedShows()
  }

  private func fetchShowProgress(_ baseShow: BaseShow) -> Single<WatchedShowEntity> {
    guard let show = baseShow.show else { Swift.fatalError("Can't fetch show progress without show") }

    return showProgressRepository.fetchShowProgress(ids: show.ids)
      .flatMap { [unowned self] in return self.mapToEntity(baseShow, builder: $0) }
  }

  private func mapToEntity(_ baseShow: BaseShow, builder: WatchedShowBuilder) -> Single<WatchedShowEntity> {
    guard let show = baseShow.show else { Swift.fatalError("Can't create WatchedShowEntity without show") }

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

    return Single.just(entity).observeOn(schedulers.networkScheduler)
  }
}
