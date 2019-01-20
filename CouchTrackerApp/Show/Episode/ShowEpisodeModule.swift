import CouchTrackerCore

final class ShowEpisodeModule {
  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    let trakt = Environment.instance.trakt
    let schedulers = Environment.instance.schedulers
    let appConfigsObservable = Environment.instance.appConfigurationsObservable
    let hideSpecials = Environment.instance.currentAppState.hideSpecials
    let showSynchronizer = Environment.instance.showSynchronizer
    let imageRepository = Environment.instance.imageRepository

    let showEpisodeNetwork = ShowEpisodeMoyaNetwork(trakt: trakt, schedulers: schedulers)

    let repository = ShowEpisodeAPIRepository(network: showEpisodeNetwork,
                                              schedulers: schedulers,
                                              synchronizer: showSynchronizer,
                                              appConfigurationsObservable: appConfigsObservable,
                                              hideSpecials: hideSpecials)

    let interactor = ShowEpisodeService(repository: repository, imageRepository: imageRepository)
    let presenter = ShowEpisodeDefaultPresenter(interactor: interactor, show: show)

    return ShowEpisodeViewController(presenter: presenter)
  }
}
