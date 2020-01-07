import TraktSwift
import RxSwift
import Moya

typealias TraktShow = TraktSwift.Show
typealias DomainShow = CouchTrackerSync.Show

struct ShowDataForSyncing: DataStruct {
  let progressShow: BaseShow
  let show: TraktShow
  let seasons: [Season]

  var showIds: ShowIds {
    return show.ids
  }
}

public enum SyncError: Error, EnumPoetry {
  case showIsNil
  case missingEpisodes(showIds: ShowIds, baseSeason: BaseSeason, season: Season)
}

struct WatchedProgressOptions: Hashable {
  let hidden: Bool
  let specials: Bool
  let countSpecials: Bool

  init(hidden: Bool = false, specials: Bool = false, countSpecials: Bool = false) {
    self.hidden = hidden
    self.specials = specials
    self.countSpecials = countSpecials
  }
}

struct SyncOptions: Hashable {
  let watchedProgress: WatchedProgressOptions

  init(watchedProgress: WatchedProgressOptions = WatchedProgressOptions()) {
    self.watchedProgress = watchedProgress
  }
}

func startSync(options: SyncOptions) -> Observable<WatchedShow> {
  return syncMain(options)
}

private func syncMain(_ options: SyncOptions) -> Observable<WatchedShow> {
  let genresObservable = Current.genres()

  let showAndSeasonsObservable = Current.syncWatchedShows([.full, .noSeasons])
    .flatMap { Observable.from($0) }
    .flatMap { watchedProgress(options: options.watchedProgress, baseShow: $0) }
    .flatMap { seasonsForShow(showData: $0) }

  return Observable.zip(showAndSeasonsObservable, genresObservable).map(createWatchedShow(showData:allGenres:))
}

private func watchedProgress(options: WatchedProgressOptions, baseShow: BaseShow) -> Observable<ShowDataForSyncing> {
  guard let show = baseShow.show else { return Observable.error(SyncError.showIsNil) }
  return Current.watchedProgress(options, show.ids)
    .map { ShowDataForSyncing(progressShow: $0, show: show, seasons: []) }
}

private func seasonsForShow(showData: ShowDataForSyncing) -> Observable<ShowDataForSyncing> {
  return Current.seasonsForShow(showData.showIds, [.full, .episodes])
    .map { ShowDataForSyncing(progressShow: showData.progressShow, show: showData.show, seasons: $0) }
}

private func genresFromSlugs(allGenres: Set<Genre>, slugs: [String]) -> [Genre] {
  return slugs.compactMap { slug in
    allGenres.first { $0.slug == slug }
  }
}

private func createWatchedShow(showData: ShowDataForSyncing, allGenres: Set<Genre>) throws -> WatchedShow {
  let showGenres = genresFromSlugs(allGenres: allGenres, slugs: showData.show.genres ?? [])

  let watchedSeasons = try createWatchedSeasons(showIds: showData.showIds,
                                            baseSeasons: showData.progressShow.seasons ?? [],
                                            seasons: showData.seasons)

  let show = mapTraktShowToDomainShow(traktShow: showData.show, genres: showGenres, seasons: watchedSeasons)

  return createWatchedShow(show: show, progressShow: showData.progressShow)
}

private func createWatchedSeasons(showIds: ShowIds, baseSeasons: [BaseSeason], seasons: [Season]) throws -> [WatchedSeason] {
  return try seasons.compactMap { season -> WatchedSeason? in
    guard let baseSeason = baseSeasons.first(where: { season.number == $0.number }) else { return nil }
    return try createWatchedSeason(showIds: showIds, baseSeason: baseSeason, season: season)
  }
}

private func createWatchedSeason(showIds: ShowIds, baseSeason: BaseSeason, season: Season) throws -> WatchedSeason {
  let episodes = season.episodes?.compactMap { episode -> WatchedEpisode? in
    guard let baseEpisode = baseSeason.episodes.first(where: { episode.number == $0.number }) else { return nil }
    return createWatchedEpisode(showIds: showIds, baseEpisode: baseEpisode, episode: episode)
  }

  guard let validEpisodes = episodes else {
    throw SyncError.missingEpisodes(showIds: showIds, baseSeason: baseSeason, season: season)
  }

  return WatchedSeason(showIds: showIds,
                       seasonIds: season.ids,
                       number: season.number,
                       aired: season.airedEpisodes,
                       completed: baseSeason.completed,
                       episodes: validEpisodes,
                       overview: season.overview,
                       title: season.title,
                       firstAired: season.firstAired,
                       network: season.network)
}

private func createWatchedEpisode(showIds: ShowIds, baseEpisode: BaseEpisode, episode: TraktSwift.Episode) -> WatchedEpisode {
  let episode = Episode(ids: episode.ids,
                        showIds: showIds,
                        title: episode.title,
                        overview: episode.overview,
                        number: episode.number,
                        season: episode.season,
                        firstAired: episode.firstAired,
                        absoluteNumber: episode.absoluteNumber,
                        runtime: episode.runtime,
                        rating: episode.rating,
                        votes: episode.votes)

  return WatchedEpisode(episode: episode, lastWatched: baseEpisode.lastWatchedAt)
}

private func mapTraktShowToDomainShow(traktShow: TraktShow, genres: [Genre], seasons: [WatchedSeason]) -> DomainShow {
  return DomainShow(ids: traktShow.ids,
                    title: traktShow.title,
                    overview: traktShow.overview,
                    network: traktShow.network,
                    genres: genres,
                    status: traktShow.status,
                    firstAired: traktShow.firstAired,
                    seasons: seasons)
}

private func createWatchedShow(show: DomainShow, progressShow: BaseShow) -> WatchedShow {
  let nextEpisode = progressShow.nextEpisode.flatMap { findEpisodeOnShow(show: show, episode: $0) }
  let lastEpisode = progressShow.lastEpisode.flatMap { findEpisodeOnShow(show: show, episode: $0) }

  return WatchedShow(show: show,
                     aired: progressShow.aired,
                     completed: progressShow.completed,
                     nextEpisode: nextEpisode,
                     lastEpisode: lastEpisode,
                     lastWatched: progressShow.lastWatchedAt)
}

private func findEpisodeOnShow(show: DomainShow, episode: TraktSwift.Episode) -> WatchedEpisode? {
  let season = show.seasons.first { $0.number == episode.season }
  return season?.episodes.first { $0.episode.number == episode.number }
}
