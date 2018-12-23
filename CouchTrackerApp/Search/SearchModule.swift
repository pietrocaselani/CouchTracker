import CouchTrackerCore
import TraktSwift
import UIKit

final class SearchModule {
  private init() {}

  static func setupModule(searchTypes: [SearchType]) -> BaseView {
    guard let viewController = R.storyboard.search.searchViewController() else {
      Swift.fatalError("Could not instantiate view controller from storyboard")
    }

    let environment = Environment.instance
    let tmdb = environment.tmdb
    let tvdb = environment.tvdb
    let schedulers = environment.schedulers

    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)

    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                schedulers: schedulers)

    viewController.imageRepository = imageRepository

    let searchBaseView = SearchViewModule.setupModule(searchTypes: searchTypes, resultOutput: viewController)

    guard let searchView = searchBaseView as? SearchView else {
      Swift.fatalError("searchBaseView should be an instance of SearchView")
    }

    viewController.searchView = searchView

    return viewController
  }
}
