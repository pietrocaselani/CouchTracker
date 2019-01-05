import CouchTrackerCore
import TraktSwift

final class SearchiOSRouter: SearchRouter {
  weak var viewController: UIViewController?

  func showViewFor(entity: SearchResultEntity) {
    let view: BaseView
    switch entity.type {
    case let .movie(movie):
      view = MovieDetailsModule.setupModule(movieIds: movie.ids)
    case let .show(show):
      let showEntity = ShowEntityMapper.entity(for: show)
      let watchedShow = WatchedShowEntity(show: showEntity,
                                          aired: nil,
                                          completed: nil,
                                          nextEpisode: nil,
                                          lastWatched: nil,
                                          seasons: [WatchedSeasonEntity]())
      view = ShowManagerModule.setupModule(for: watchedShow)
    }

    present(view: view)
  }

  private func present(view: BaseView) {
    guard let navigationController = viewController?.navigationController else { return }

    guard let nextViewController = view as? UIViewController else {
      Swift.fatalError("view should be an instance of UIViewController")
    }

    navigationController.pushViewController(nextViewController, animated: true)
  }
}
