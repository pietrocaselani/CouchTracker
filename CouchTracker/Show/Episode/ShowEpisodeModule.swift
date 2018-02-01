import UIKit

final class ShowEpisodeModule {
  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    guard let view = R.storyboard.showEpisode.showEpisodeViewController() else {
      fatalError("Unable to instantiate view controller from Storyboard")
    }

    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)

    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let showProgressRepository = ShowProgressAPIRepository(trakt: trakt, schedulers: schedulers)
    let showProgressInteractor = ShowProgressService(repository: showProgressRepository)

    let repository = ShowEpisodeAPIRepository(trakt: trakt, schedulers: schedulers)

    let interactor = ShowEpisodeService(repository: repository,
                                        showProgressInteractor: showProgressInteractor,
                                        imageRepository: imageRepository)

    let presenter = ShowEpisodeiOSPresenter(view: view, interactor: interactor, show: show)

    view.presenter = presenter

    return view
  }
}
