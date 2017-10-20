import UIKit

final class AppConfigurationsiOSRouter: AppConfigurationsRouter {
  private let viewController: UIViewController
  private let traktProvider: TraktProvider

  init(viewController: UIViewController, traktProvider: TraktProvider) {
    self.viewController = viewController
    self.traktProvider = traktProvider
  }

  func showTraktLogin(output: TraktLoginOutput) {
    guard let navigationController = viewController.navigationController else { return }

    let popviewControllerOutput = PopNavigationControllerOutput(viewController: viewController)

    let outputs = CompositeLoginOutput(outputs: [popviewControllerOutput, output])

    let loginView = TraktLoginModule.setupModule(loginOutput: outputs)

    guard let loginViewController = loginView as? UIViewController else {
      fatalError("loginView should be an instance of UIViewController")
    }

    navigationController.pushViewController(loginViewController, animated: true)
  }

  func showError(message: String) {
    let errorAlert = UIAlertController.createErrorAlert(message: message)
    viewController.present(errorAlert, animated: true)
  }
}

private class PopNavigationControllerOutput: TraktLoginOutput {
  private let viewController: UIViewController

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func loggedInSuccessfully() {
    popViewController()
  }

  func logInFail(message: String) {
    popViewController()
  }

  private func popViewController() {
    viewController.navigationController?.popViewController(animated: true)
  }
}
