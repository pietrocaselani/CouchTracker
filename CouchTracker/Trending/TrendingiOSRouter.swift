import CouchTrackerCore
import RxSwift
import TraktSwift
import UIKit

final class TrendingiOSRouter: TrendingRouter {
  private weak var viewController: UIViewController?
  private let disposeBag = DisposeBag()

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func showDetails(of movie: MovieEntity) {
    let movieIds = movie.ids
    let view = MovieDetailsModule.setupModule(movieIds: movieIds)

    present(view: view)
  }

  func showDetails(of show: ShowEntity) {
    let entity = WatchedShowBuilder(ids: show.ids).createEntity(using: show)
    let view = ShowManagerModule.setupModule(for: entity)
    present(view: view)
  }

  func showError(message: String) {
    guard let viewController = viewController else { return }

    let errorAlert = UIAlertController.createErrorAlert(message: message)
    viewController.present(errorAlert, animated: true)
  }

  private func present(view: BaseView) {
    guard let navigationController = viewController?.navigationController else { return }

    guard let viewController = view as? UIViewController else {
      Swift.fatalError("view should be an instance of UIViewController")
    }

    navigationController.pushViewController(viewController, animated: true)
  }
}
