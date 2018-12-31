import CouchTrackerCore

final class AppConfigurationsiOSRouter: AppConfigurationsRouter {
  private weak var viewController: UIViewController?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func showTraktLogin(output: TraktLoginOutput) {
    guard let view = viewController else { return }

    guard let navigationController = view.navigationController else { return }

    let popviewControllerOutput = PopNavigationControllerOutput(viewController: view)

    let outputs = CompositeLoginOutput(outputs: [popviewControllerOutput, output])

    let loginView = TraktLoginModule.setupModule(loginOutput: outputs)

    guard let loginViewController = loginView as? UIViewController else {
      fatalError("loginView should be an instance of UIViewController")
    }

    navigationController.pushViewController(loginViewController, animated: true)
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

private class PopNavigationControllerOutput: TraktLoginOutput {
  private weak var viewController: UIViewController?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func loggedInSuccessfully() {
    popViewController()
  }

  func logInFail(message _: String) {
    popViewController()
  }

  private func popViewController() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
