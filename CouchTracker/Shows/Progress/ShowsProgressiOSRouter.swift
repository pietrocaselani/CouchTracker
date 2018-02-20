import UIKit

final class ShowsProgressiOSRouter: ShowsProgressRouter {
	private weak var viewController: UIViewController?

	init(viewController: UIViewController) {
		self.viewController = viewController
	}

	func show(tvShow entity: WatchedShowEntity) {
		guard let navigationController = viewController?.navigationController else { return }

		guard let showManagerView = ShowManagerModule.setupModule(for: entity) as? UIViewController else {
			fatalError("showManagerView should be an instance UIVIewController")
		}

		navigationController.pushViewController(showManagerView, animated: true)
	}
}
