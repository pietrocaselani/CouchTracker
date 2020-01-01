import RxSwift
import TraktSwift

private struct BaseShowWithGenres {
  let baseShow: BaseShow
  let genres: [Genre]

  fileprivate init(baseShow: BaseShow, genres: [Genre] = [Genre]()) {
    self.baseShow = baseShow
    self.genres = genres
  }
}

private struct ShowBuilderWithGenres {
  var builder: WatchedShowBuilder
  let genres: [Genre]

  fileprivate init(builder: WatchedShowBuilder, genres: [Genre] = [Genre]()) {
    self.builder = builder
    self.genres = genres
  }
}

public final class DefaultWatchedShowEntitiesDownloader: WatchedShowEntitiesDownloader {
  private let trakt: TraktProvider
  private let scheduler: Schedulers
  private let genreRepository: GenreRepository
  private let showSynchronizer: WatchedShowEntityDownloader

  public init(trakt: TraktProvider, genreRepository: GenreRepository, scheduler: Schedulers) {
    self.trakt = trakt
    self.scheduler = scheduler
    self.genreRepository = genreRepository
    showSynchronizer = DefaultWatchedShowEntityDownloader(trakt: trakt, scheduler: scheduler)
  }

  // MARK: - Public Interface

  public func syncWatchedShowEntities(using options: WatchedShowEntitiesSyncOptions) -> Observable<WatchedShowEntity> {
    return fetchWatchedShowsFromAPI().asObservable()
      .flatMap { [weak self] baseShows -> Observable<BaseShowWithGenres> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.mapToBaseShowWithGenres(baseShows).asObservable()
      }.flatMap { [weak self] showWithGenres -> Observable<ShowBuilderWithGenres> in
      guard let strongSelf = self else { return Observable<ShowBuilderWithGenres>.empty() }
      return strongSelf.mapToBuilderWithGenres(showWithGenres, options)
      }.map { builderWithGenres -> WatchedShowEntity in
      builderWithGenres.builder.set(genres: builderWithGenres.genres).createEntity()
      }
  }

  // MARK: - Private Interface - BaseShow with Genres

  private func mapToBaseShowWithGenres(_ shows: [BaseShow]) -> Observable<BaseShowWithGenres> {
    return genreRepository.fetchShowsGenres()
      .asObservable()
      .flatMap { genres -> Observable<BaseShowWithGenres> in
        Observable.from(shows).map { BaseShowWithGenres(baseShow: $0, genres: genres) }
      }
  }

  // MARK: - Private Interface - ShowBuilder with Genres

  private func mapToBuilderWithGenres(_ baseShowWithGenres: BaseShowWithGenres,
                                      _ options: WatchedShowEntitiesSyncOptions) -> Observable<ShowBuilderWithGenres> {
    return fetchProgress(of: baseShowWithGenres.baseShow, using: options)
      .map { builder -> ShowBuilderWithGenres in
        ShowBuilderWithGenres(builder: builder, genres: baseShowWithGenres.genres)
      }.asObservable()
  }

  // MARK: - Private Interface - Fetch Progress for show

  private func fetchProgress(of detailShow: BaseShow,
                             using options: WatchedShowEntitiesSyncOptions) -> Single<WatchedShowBuilder> {
    guard let show = detailShow.show else { Swift.fatalError("Can't fetch show progress without detailShow.show") }

    let showOptions = WatchedShowEntitySyncOptions(showIds: show.ids,
                                                   episodeExtended: options.extended,
                                                   seasonOptions: .yes(number: nil, extended: options.seasonExtended),
                                                   hiddingSpecials: options.hiddingSpecials)

    return showSynchronizer.syncWatchedShowEntitiy(using: showOptions).map { builder in
      builder.set(detailShow: detailShow)
    }
  }

  private func fetchWatchedShowsFromAPI() -> Single<[BaseShow]> {
    let target = Sync.watched(type: .shows, extended: [.full, .noSeasons])
    return trakt.sync.rx.request(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([BaseShow].self)
      .observeOn(scheduler.networkScheduler)
  }
}
