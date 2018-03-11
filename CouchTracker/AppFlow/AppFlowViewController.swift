import UIKit
import CouchTrackerCore

final class AppFlowViewController: UITabBarController, AppFlowView {
	var presenter: AppFlowPresenter!

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let presenter = presenter else {
			Swift.fatalError("view was loaded without a presenter")
		}

		self.view.backgroundColor = UIColor.ctdarkerBunker

		presenter.viewDidLoad()

		self.delegate = self
	}

	func show(pages: [ModulePage], selectedIndex: Int) {
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
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.presenter.selectTab(index: self.selectedIndex)
	}
}
