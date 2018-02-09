import UIKit
import TraktSwift

final class ShowsProgressModule {
  private init() {}

  static var showsManagerOption: ShowsManagerOption {
    return ShowsManagerOption.progress
  }

  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsProgress.showsProgressViewController() else {
      Swift.fatalError("Can't instantiate showsProgressController from Shows storyboard")
    }

    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let schedulers = Environment.instance.schedulers
    let realmProvider = Environment.instance.realmProvider

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let showProgressRepository = ShowProgressAPIRepository(trakt: trakt)

    let dataSource = ShowsProgressRealmDataSource(realmProvider: realmProvider, schedulers: schedulers)
    let router = ShowsProgressiOSRouter(viewController: view)
    let viewDataSource = ShowsProgressTableViewDataSource(imageRepository: imageRepository)
    let repository = ShowsProgressAPIRepository(trakt: trakt, dataSource: dataSource,
                                                schedulers: schedulers, showProgressRepository: showProgressRepository)
    let interactor = ShowsProgressService(repository: repository, schedulers: schedulers)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor,
                                              viewDataSource: viewDataSource, router: router)

    view.presenter = presenter

    return view
  }
}
