import CouchTrackerCore
import RxSwift
import UIKit

final class AppFlowViewController: UITabBarController {
  private let disposeBag = DisposeBag()
  var presenter: AppFlowPresenter!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let presenter = presenter else {
      Swift.fatalError("view was loaded without a presenter")
    }

    view.backgroundColor = Colors.View.background
    delegate = self

    presenter.observeViewState()
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleViewState(_ viewState: AppFlowViewState) {
    switch viewState {
    case let .showing(pages, selectedIndex):
      show(pages: pages, selectedIndex: selectedIndex)
    default: break
    }
  }

  private func show(pages: [ModulePage], selectedIndex: Int) {
    let viewControllers = pages.map { modulePage -> UIViewController in
      guard let viewController = modulePage.page as? UIViewController else {
        Swift.fatalError("page should be an instance of UIViewController")
      }

      viewController.title = modulePage.title

      return viewController
    }

    self.viewControllers = viewControllers
    self.selectedIndex = selectedIndex
  }
}

extension AppFlowViewController: UITabBarControllerDelegate {
  func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
    presenter.selectTab(index: selectedIndex)
  }
}
