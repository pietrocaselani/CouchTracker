import CouchTrackerSync

func mapShowToWatchedShowEntity(show: Show) -> WatchedShowEntity {
  WatchedShowEntity(
    show: mapShowToShowEntity(show: show),
    aired: show.aired,
    completed: show.watched?.completed,
    nextEpisode: show.nextEpisode.map(mapEpisodeToWatchedEpisodeEntity(episode:)),
    lastWatched: show.watched?.lastEpisode.lastWatched,
    seasons: show.seasons.map(mapSeasonToWatchedSeasonEntity(season:))
  )
}

private func mapSeasonToWatchedSeasonEntity(season: Season) -> WatchedSeasonEntity {
  WatchedSeasonEntity(
    showIds: season.showIds,
    seasonIds: season.seasonIds,
    number: season.number,
    aired: season.aired,
    completed: season.completed,
    episodes: season.episodes.map(mapEpisodeToWatchedEpisodeEntity(episode:)),
    overview: season.overview,
    title: season.title
  )
}

private func mapEpisodeToWatchedEpisodeEntity(episode: Episode) -> WatchedEpisodeEntity {
  WatchedEpisodeEntity(episode: mapEpisodeToEpisodeEntity(episode: episode), lastWatched: episode.lastWatched)
}

private func mapEpisodeToEpisodeEntity(episode: Episode) -> EpisodeEntity {
  EpisodeEntity(
    ids: episode.ids,
    showIds: episode.showIds,
    title: episode.title ?? CouchTrackerCoreStrings.toBeAnnounced(),
    overview: episode.overview,
    number: episode.number,
    season: episode.season,
    firstAired: episode.firstAired,
    absoluteNumber: episode.absoluteNumber
  )
}

private func mapShowToShowEntity(show: Show) -> ShowEntity {
  ShowEntity(
    ids: show.ids,
    title: show.title,
    overview: show.overview,
    network: show.network,
    genres: show.genres,
    status: show.status,
    firstAired: show.firstAired)
}
