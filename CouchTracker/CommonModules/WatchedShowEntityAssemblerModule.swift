import CouchTrackerCore

final class WatchedShowEntityAssemblerModule {
  private init() {}

  static func setupModule() -> WatchedShowEntityAssembler {
    let trakt = Environment.instance.trakt
    let schedulers = Environment.instance.schedulers

    let showProgressRepository = ShowWatchedProgressAPIRepository(trakt: trakt)
    let seasonsRepository = ShowSeasonsAPIRepository(trakt: trakt)
    let episodeRepository = EpisodeDetailsAPIRepository(trakt: trakt)
    let genreRepository = GenreModule.setupGenreRepository()
    let seasonsAssembler = WatchedSeasonsAssembler(seasonRepository: seasonsRepository, schedulers: schedulers)

    return WatchedShowEntityAssembler(showProgressRepository: showProgressRepository,
                                      watchedSeasonsAssembler: seasonsAssembler,
                                      episodeRepository: episodeRepository,
                                      genreRepository: genreRepository,
                                      schedulers: schedulers)
  }
}
