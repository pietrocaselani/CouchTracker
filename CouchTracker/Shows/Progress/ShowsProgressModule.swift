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

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    let router = ShowsProgressiOSRouter(viewController: view)
    let dataSource = ShowsProgressTableViewDataSource(imageRepository: imageRepository)
    let repository = ShowsProgressAPIRepository(trakt: trakt, schedulers: schedulers)
    let interactor = ShowsProgressService(repository: repository, schedulers: schedulers)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor,
                                              dataSource: dataSource, router: router)

    view.presenter = presenter

    return view
  }
}
