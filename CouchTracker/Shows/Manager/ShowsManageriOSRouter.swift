import UIKit

final class ShowsManageriOSRouter: ShowsManagerRouter {
  private weak var viewController: UIViewController?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func showNeedsLogin() {
    let message = "You need to log in on Trakt to use this screen"
    let alert = UIAlertController(title: "Trakt", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    }))
    viewController?.present(alert, animated: true, completion: nil)
  }

  func show(option: ShowsManagerOption) {
    guard let navigationController = viewController?.navigationController else { return }

    let moduleView = moduleViewFor(option: option)

    guard let view = moduleView as? UIViewController else {
      fatalError("moduleView should be an instance of UIViewController")
    }

    navigationController.pushViewController(view, animated: true)
  }

  private func moduleViewFor(option: ShowsManagerOption) -> BaseView {
    switch option {
    case .progress:
      return ShowsProgressModule.setupModule()
    case .now:
      return ShowsNowModule.setupModule()
    }
  }
}
