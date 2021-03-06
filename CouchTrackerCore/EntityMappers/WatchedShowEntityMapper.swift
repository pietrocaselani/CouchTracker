public enum WatchedShowEntityMapper {
  private typealias Strings = CouchTrackerCoreStrings

  public static func viewModel(for entity: WatchedShowEntity) -> WatchedShowViewModel {
    let nextEpisodeTitle = entity.nextEpisode.map { "\($0.episode.season)x\($0.episode.number) \($0.episode.title)" }
    let nextEpisodeDateText = nextEpisodeDate(for: entity)
    let statusText = status(for: entity)

    return WatchedShowViewModel(title: entity.show.title ?? Strings.toBeAnnounced(),
                                nextEpisode: nextEpisodeTitle,
                                nextEpisodeDate: nextEpisodeDateText,
                                status: statusText,
                                tmdbId: entity.show.ids.tmdb)
  }

  public static func status(for entity: WatchedShowEntity) -> String {
    let episodesRemaining = (entity.aired ?? 0) - (entity.completed ?? 0)
    var status = episodesRemaining == 0 ? "" : Strings.episodesRemaining(count: episodesRemaining)

    if let network = entity.show.network {
      status = episodesRemaining == 0 ? network : "\(status) - \(network)"
    }

    return status
  }

  public static func nextEpisodeDate(for entity: WatchedShowEntity) -> String {
    if let nextEpisodeDate = entity.nextEpisode?.episode.firstAired?.shortString() {
      return nextEpisodeDate
    }

    return entity.show.status.map { Strings.showStatus(status: $0) } ?? Strings.unknown()
  }
}
