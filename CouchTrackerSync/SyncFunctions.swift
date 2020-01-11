import CouchTrackerPersistence
import RxSwift
import Moya

typealias TraktShow = TraktSwift.Show
typealias DomainShow = CouchTrackerSync.Show

func startSync(_ options: SyncOptions = SyncOptions()) -> Observable<Show> {
  let genresObservable = Current.api.genres().asObservable()

  let showAndSeasonsObservable = Current.api.syncWatchedShows([.full, .noSeasons])
    .asObservable()
    .flatMap { Observable.from($0) }
    .flatMap { watchedProgress(options: options.watchedProgress, baseShow: $0) }
    .flatMap { seasonsForShow(showData: $0) }

  return Observable.zip(showAndSeasonsObservable, genresObservable).map(createWatchedShow(showData:allGenres:))
}

private func watchedProgress(options: WatchedProgressOptions, baseShow: BaseShow) -> Single<ShowDataForSyncing> {
  guard let show = baseShow.show else { return Single.error(SyncError.showIsNil) }
  return Current.api.watchedProgress(options, show.ids)
    .map { ShowDataForSyncing(progressShow: $0, show: show, seasons: []) }
}

private func seasonsForShow(showData: ShowDataForSyncing) -> Single<ShowDataForSyncing> {
  return Current.api.seasonsForShow(showData.showIds, [.full, .episodes])
    .map { showData.copy(seasons: .new($0)) }
}

private func genresFromSlugs(allGenres: Set<Genre>, slugs: [String]) -> [Genre] {
  return slugs.compactMap { slug in
    allGenres.first { $0.slug == slug }
  }
}

private func createWatchedShow(showData: ShowDataForSyncing, allGenres: Set<Genre>) throws -> Show {
  let showGenres = genresFromSlugs(allGenres: allGenres, slugs: showData.show.genres ?? [])

  let watchedSeasons = try createWatchedSeasons(showIds: showData.showIds,
                                                baseSeasons: showData.progressShow.seasons ?? [],
                                                seasons: showData.seasons)

  return mapTraktShowToDomainShow(showData: showData, genres: showGenres, seasons: watchedSeasons)
}

private func createWatchedSeasons(showIds: ShowIds, baseSeasons: [BaseSeason], seasons: [TraktSwift.Season]) throws -> [Season] {
  return try seasons.compactMap { season -> Season? in
    guard let baseSeason = baseSeasons.first(where: { season.number == $0.number }) else { return nil }
    return try createWatchedSeason(showIds: showIds, baseSeason: baseSeason, season: season)
  }
}

private func createWatchedSeason(showIds: ShowIds, baseSeason: BaseSeason, season: TraktSwift.Season) throws -> Season {
  let episodes = season.episodes?.compactMap { episode -> Episode? in
    guard let baseEpisode = baseSeason.episodes.first(where: { episode.number == $0.number }) else { return nil }
    return createWatchedEpisode(showIds: showIds, baseEpisode: baseEpisode, episode: episode)
  }

  guard let validEpisodes = episodes else {
    throw SyncError.missingEpisodes(showIds: showIds, baseSeason: baseSeason, season: season)
  }

  return Season(showIds: showIds,
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

private func createWatchedEpisode(showIds: ShowIds, baseEpisode: BaseEpisode, episode: TraktSwift.Episode) -> Episode {
  return Episode(ids: episode.ids,
                 showIds: showIds,
                 title: episode.title,
                 overview: episode.overview,
                 number: episode.number,
                 season: episode.season,
                 firstAired: episode.firstAired,
                 absoluteNumber: episode.absoluteNumber,
                 runtime: episode.runtime,
                 rating: episode.rating,
                 votes: episode.votes,
                 lastWatched: baseEpisode.lastWatchedAt)
}

private func mapTraktShowToDomainShow(showData: ShowDataForSyncing, genres: [Genre], seasons: [Season]) -> DomainShow {
  let progressShow = showData.progressShow
  let traktShow = showData.show

  let nextEpisode = progressShow.nextEpisode.flatMap { findEpisodeOnSeasons(seasons: seasons, episode: $0) }

  let lastEpisode = progressShow.lastEpisode.flatMap { findEpisodeOnSeasons(seasons: seasons, episode: $0) }
  let completed = progressShow.completed

  let watched = zip(a: completed, b: lastEpisode).map(DomainShow.Watched.init(completed:lastEpisode:))

  return DomainShow(ids: traktShow.ids,
                    title: traktShow.title,
                    overview: traktShow.overview,
                    network: traktShow.network,
                    genres: genres,
                    status: traktShow.status,
                    firstAired: traktShow.firstAired,
                    seasons: seasons,
                    aired: progressShow.aired,
                    nextEpisode: nextEpisode,
                    watched: watched)
}

private func findEpisodeOnSeasons(seasons: [Season], episode: TraktSwift.Episode) -> Episode? {
  let season = seasons.first { $0.number == episode.season }
  return season?.episodes.first { $0.number == episode.number }
}

private func zip<A, B>(a: A?, b: B?) -> (A,B)? {
  guard let aValue = a, let bValue = b else { return nil }
  return (aValue, bValue)
}
