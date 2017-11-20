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
    let diskCache = Environment.instance.diskCache
    let memoryCache = Environment.instance.memoryCache

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                cache: diskCache)

    let showProgressRepository = ShowProgressAPIRepository(trakt: trakt, cache: memoryCache)
    let showProgressInteractor = ShowProgressService(repository: showProgressRepository)

    let router = ShowsProgressiOSRouter(viewController: view)
    let dataSource = ShowsProgressTableViewDataSource(imageRepository: imageRepository)
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: memoryCache)
    let interactor = ShowsProgressService(repository: repository, showProgressInteractor: showProgressInteractor)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor,
                                              dataSource: dataSource, router: router)

    view.presenter = presenter

    return view
  }
}
