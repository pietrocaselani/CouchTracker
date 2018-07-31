import Moya
import RxSwift
import TraktSwift

public final class ShowsProgressAPIRepository: ShowsProgressRepository {
  private let network: ShowsProgressNetwork
  private let dataSource: ShowsProgressDataSource
  private let schedulers: Schedulers
  private let showProgressRepository: ShowProgressRepository
  private let appConfigurationsObservable: AppConfigurationsObservable
  private var hideSpecials: Bool
  private let disposeBag = DisposeBag()

  public init(network: ShowsProgressNetwork, dataSource: ShowsProgressDataSource, schedulers: Schedulers,
              showProgressRepository: ShowProgressRepository, appConfigurationsObservable: AppConfigurationsObservable,
              hideSpecials: Bool) {
    self.network = network
    self.dataSource = dataSource
    self.schedulers = schedulers
    self.showProgressRepository = showProgressRepository
    self.appConfigurationsObservable = appConfigurationsObservable
    self.hideSpecials = hideSpecials
  }

  public func fetchWatchedShows(extended: Extended) -> Observable<[WatchedShowEntity]> {
    appConfigurationsObservable.observe()
      .subscribe(onNext: { [unowned self] newState in
        self.hideSpecials = newState.hideSpecials
        self.updateShowsFromAPI(extended)
      }).disposed(by: disposeBag)

    updateShowsFromAPI(extended)

    return fetchWatchedShowsFromDataSource().subscribeOn(schedulers.dataSourceScheduler)
  }

  private func updateShowsFromAPI(_ extended: Extended) {
    fetchWatchedShowsFromAPI(extended)
      .observeOn(schedulers.dataSourceScheduler)
      .do(onNext: { [unowned self] entities in
        try self.dataSource.addWatched(shows: entities)
      })
      .subscribe()
      .disposed(by: disposeBag)
  }

  private func fetchWatchedShowsFromAPI(_ extended: Extended) -> Observable<[WatchedShowEntity]> {
    let api = network.fetchWatchedShows(extended: extended).asObservable()

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

    return showProgressRepository.fetchShowProgress(ids: show.ids, hideSpecials: hideSpecials)
      .flatMap { [unowned self] in self.mapToEntity(baseShow, builder: $0) }
  }

  private func mapToEntity(_ baseShow: BaseShow, builder: WatchedShowBuilder) -> Single<WatchedShowEntity> {
    guard let show = baseShow.show else { Swift.fatalError("Can't create WatchedShowEntity without show") }

    let showIds = builder.ids

    let showEntity = ShowEntityMapper.entity(for: show)
    let episodeEntity = builder.episode.map { EpisodeEntityMapper.entity(for: $0, showIds: showIds) }

    let aired = builder.progressShow?.aired ?? 0
    let completed = builder.progressShow?.completed ?? 0

    let lastWatched = baseShow.lastWatchedAt

    var seasonEntities = [WatchedSeasonEntity]()
    if let baseSeasons = builder.progressShow?.seasons {
      seasonEntities = baseSeasons.map { baseSeason in
        let watchedEpisodes = baseSeason.episodes.map { baseEpisode in
          WatchedEpisodeEntity(showIds: showIds, number: baseEpisode.number, lastWatchedAt: baseEpisode.lastWatchedAt)
        }

        return WatchedSeasonEntity(showIds: showIds,
                                   number: baseSeason.number,
                                   aired: baseSeason.aired,
                                   completed: baseSeason.completed,
                                   episodes: watchedEpisodes)
      }
    }

    let entity = WatchedShowEntity(show: showEntity,
                                   aired: aired,
                                   completed: completed,
                                   nextEpisode: episodeEntity,
                                   lastWatched: lastWatched,
                                   seasons: seasonEntities)

    return Single.just(entity).observeOn(schedulers.networkScheduler)
  }
}
