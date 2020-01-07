import RxSwift
import TraktSwift

public final class DefaultWatchedShowEntityDownloader: WatchedShowEntityDownloader {
  private let trakt: TraktProvider
  private let scheduler: Schedulers

  public init(trakt: TraktProvider, scheduler: Schedulers) {
    self.trakt = trakt
    self.scheduler = scheduler
  }

  // MARK: - Public Interface

  public func syncWatchedShowEntitiy(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowBuilder> {
    return setShowProgress(using: options, into: WatchedShowBuilder(ids: options.showIds))
      .flatMap { [weak self] builder -> Single<WatchedShowBuilder> in
        guard let strongSelf = self else { return Single.just(builder) }

        return strongSelf.syncSeasons(using: options, into: builder)
      }.flatMap { [weak self] builder -> Single<WatchedShowBuilder> in
      guard let strongSelf = self else { return Single.just(builder) }
      return strongSelf.setNextEpisodeDetails(using: options, into: builder)
      }
  }

  // MARK: - Private Interface - Next Episode

  private func setNextEpisodeDetails(using options: WatchedShowEntitySyncOptions,
                                     into builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    guard let nextEpisode = builder.progressShow?.nextEpisode else { return Single.just(builder) }

    return fetchDetailsFromAPI(of: nextEpisode, using: options).map {
      WatchedEpisodeEntityBuilder(showIds: options.showIds, episode: $0)
    }.map { episodeBuilder in
      builder.set(episode: episodeBuilder.createEntity())
    }
  }

  private func fetchDetailsFromAPI(of episode: Episode,
                                   using options: WatchedShowEntitySyncOptions) -> Single<Episode> {
    let target = Episodes.summary(showId: options.showIds.realId,
                                  season: episode.season,
                                  episode: episode.number,
                                  extended: options.episodeExtended)
    return trakt.episodes.rx.request(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(Episode.self)
      .observeOn(scheduler.networkScheduler)
  }

  // MARK: - Private Interface - Fetch show progress

  private func setShowProgress(using options: WatchedShowEntitySyncOptions,
                               into builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    return fetchProgressFromAPI(options: options)
      .map { progressShow in
        builder.set(progressShow: progressShow)
      }
  }

  private func fetchProgressFromAPI(options: WatchedShowEntitySyncOptions) -> Single<BaseShow> {
    let target = Shows.watchedProgress(showId: options.showIds.realId,
                                       hidden: !options.hidingSpecials,
                                       specials: !options.hidingSpecials,
                                       countSpecials: !options.hidingSpecials)

    return trakt.shows.rx.request(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(BaseShow.self)
      .observeOn(scheduler.networkScheduler)
  }

  // MARK: - Private Interface - Fetch all seasons

  private func syncSeasons(using options: WatchedShowEntitySyncOptions,
                           into builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    guard case let .yes(number, extended) = options.seasonOptions else {
      return Single.just(builder)
    }

    return setSeasons(using: options, number: number, seasonExtended: extended, into: builder)
  }

  private func setSeasons(using options: WatchedShowEntitySyncOptions,
                          number: Int?,
                          seasonExtended: [Extended],
                          into builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    return fetchSeasonsFromAPI(using: options, seasonExtended: seasonExtended, number: number)
      .map { seasons -> [WatchedSeasonEntityBuilder] in
        seasons.map { season -> WatchedSeasonEntityBuilder in
          let progressSeasons = builder.progressShow?.seasons

          return DefaultWatchedShowEntityDownloader.createSeasonBuilder(for: options.showIds,
                                                                        using: season,
                                                                        progressSeasons: progressSeasons)
        }
      }.map {
      let seasons = $0.map { $0.createEntity() }
      return builder.set(seasons: seasons)
      }
  }

  private static func createSeasonBuilder(for show: ShowIds,
                                          using season: Season,
                                          progressSeasons: [BaseSeason]?) -> WatchedSeasonEntityBuilder {
    var builder = WatchedSeasonEntityBuilder(showIds: show).set(detailSeason: season)

    let progressSeason = progressSeasons?.first(where: { $0.number == season.number })
    builder = builder.set(progressSeason: progressSeason)

    return setEpisodes(into: builder, of: season)
  }

  private func fetchSeasonsFromAPI(using options: WatchedShowEntitySyncOptions,
                                   seasonExtended: [Extended],
                                   number: Int?) -> Single<[Season]> {
    let target = Seasons.summary(showId: options.showIds.realId, extended: seasonExtended)
    let seasonsSingle = trakt.seasons.rx.request(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([Season].self)
      .observeOn(scheduler.networkScheduler)

    guard let seasonNumber = number else { return seasonsSingle }

    return seasonsSingle.map { seasons in seasons.filter { $0.number == seasonNumber } }
  }

  // MARK: - Private interface - Fetch episodes for season

  private static func setEpisodes(into builder: WatchedSeasonEntityBuilder,
                                  of season: Season) -> WatchedSeasonEntityBuilder {
    guard let episodes = season.episodes else { return builder }

    let episodeBuilders = episodes.map { episode -> WatchedEpisodeEntityBuilder in
      let episodeBuilder = WatchedEpisodeEntityBuilder(showIds: builder.showIds, episode: episode)
      let watchedEpisode = builder.progressSeason?.episodes.first(where: { $0.number == episode.number })
      return episodeBuilder.set(lastWatched: watchedEpisode?.lastWatchedAt)
    }

    return builder.set(episodes: episodeBuilders)
  }
}
