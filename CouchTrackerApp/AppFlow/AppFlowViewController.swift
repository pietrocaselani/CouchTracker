import CouchTrackerCore
import RxSwift
import UIKit

final class AppFlowViewController: UITabBarController {
  private let disposeBag = DisposeBag()
  private let presenter: AppFlowPresenter

  init(presenter: AppFlowPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

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
