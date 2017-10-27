import UIKit

final class ShowDetailsiOSRouter: ShowDetailsRouter {
  private weak var viewController: UIViewController?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func showError(message: String) {
    guard let viewController = viewController else { return }

    let errorAlert = UIAlertController.createErrorAlert(message: message)
    viewController.present(errorAlert, animated: true)
  }
}
