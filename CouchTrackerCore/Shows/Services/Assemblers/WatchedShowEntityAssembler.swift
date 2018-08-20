import RxSwift
import TraktSwift

public final class WatchedShowEntityAssembler {
  private let showProgressRepository: ShowWatchedProgressRepository
  private let episodeRepository: EpisodeDetailsRepository
  private let watchedSeasonsAssembler: WatchedSeasonsAssembler
  private let genreRepository: GenreRepository
  private let schedulers: Schedulers

  public init(showProgressRepository: ShowWatchedProgressRepository,
              watchedSeasonsAssembler: WatchedSeasonsAssembler,
              episodeRepository: EpisodeDetailsRepository,
              genreRepository: GenreRepository,
              schedulers: Schedulers) {
    self.showProgressRepository = showProgressRepository
    self.watchedSeasonsAssembler = watchedSeasonsAssembler
    self.episodeRepository = episodeRepository
    self.genreRepository = genreRepository
    self.schedulers = schedulers
  }

  public func fetchProgress(for ids: ShowIds, hiddingSpecials: Bool) -> Observable<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)

    return setShowProgress(for: ids, hiddingSpecials: hiddingSpecials, into: builder)
      .flatMap { [weak self] builder -> Observable<WatchedShowBuilder> in
        guard let strongSelf = self else { return Observable.just(builder) }
        return strongSelf.setGenres(into: builder)
      }.flatMap { [weak self] builder -> Observable<WatchedShowBuilder> in
        guard let strongSelf = self else { return Observable.just(builder) }
        return strongSelf.setNextEpisodeDetails(into: builder)
      }.flatMap { [weak self] builder -> Observable<WatchedShowBuilder> in
        guard let strongSelf = self else { return Observable.just(builder) }
        return strongSelf.setSeasons(into: builder)
      }
  }

  public func fetchProgress(for baseShow: BaseShow, hiddingSpecials: Bool) -> Observable<WatchedShowBuilder> {
    guard let show = baseShow.show else { Swift.fatalError("Can't fetch show progress without show") }

    return fetchProgress(for: show.ids, hiddingSpecials: hiddingSpecials).map { $0.set(detailShow: baseShow) }
  }

  private func setShowProgress(for show: ShowIds, hiddingSpecials: Bool,
                               into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    return showProgressRepository.fetchShowWatchedProgress(showId: show, hideSpecials: hiddingSpecials)
      .observeOn(schedulers.networkScheduler)
      .map { builder.set(progressShow: $0) }
      .asObservable()
  }

  private func setGenres(into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    return genreRepository.fetchShowsGenres().map { builder.set(genres: $0) }.asObservable()
  }

  private func setSeasons(into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    return watchedSeasonsAssembler.fetchWatchedSeasons(using: builder)
  }

  private func setNextEpisodeDetails(into builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let nextEpisode = builder.progressShow?.nextEpisode else { return Observable.just(builder) }

    let single = episodeRepository.fetchDetailsOf(episode: nextEpisode.number, season: nextEpisode.season,
                                                  from: builder.ids, extended: .full)

    return single.map { WatchedEpisodeEntityBuilder(showIds: builder.ids, episode: $0) }
      .map { builder.set(episode: $0.createEntity()) }
      .catchErrorJustReturn(builder)
      .asObservable()
      .observeOn(schedulers.networkScheduler)
  }
}
