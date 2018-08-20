import CouchTrackerCore

final class WatchedShowsAssemblerModule {
  private init() {}

  static func setupModule() -> WatchedShowsAssembler {
    let trakt = Environment.instance.trakt
    let schedulers = Environment.instance.schedulers

    let watchedShowsRepository = WatchedShowsAPIRepository(trakt: trakt)

    let watchedShowEntityAssembler = WatchedShowEntityAssemblerModule.setupModule()

    return WatchedShowsAssembler(watchedShowsRepository: watchedShowsRepository,
                                 watchedShowEntityAssembler: watchedShowEntityAssembler,
                                 schedulers: schedulers)
  }
}
