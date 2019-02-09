import CouchTrackerCore
import TraktSwift

final class AppStateiOSRouter: AppStateRouter {
  weak var viewController: UIViewController?

  func showTraktLogin() {
    guard let view = viewController else { return }

    guard let navigationController = view.navigationController else { return }

    let loginView = TraktLoginModule.setupModule()

    guard let loginViewController = loginView as? UIViewController else {
      Swift.fatalError("loginView should be an instance of UIViewController")
    }

    navigationController.pushViewController(loginViewController, animated: true)
  }

  func finishLogin() {
    viewController?.navigationController?.popViewController(animated: true)
  }

  func showExternal(url: URL) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  func showError(message: String) {
    guard let view = viewController else { return }

    let errorAlert = UIAlertController.createErrorAlert(message: message)
    view.present(errorAlert, animated: true)
  }
}
