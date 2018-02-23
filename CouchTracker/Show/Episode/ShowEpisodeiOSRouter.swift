import UIKit
import CouchTrackerCore

final class ShowEpisodeiOSRouter: ShowEpisodeRouter {
	private weak var view: UIViewController?

	init(view: UIViewController) {
		self.view = view
	}

	func showError(message: String) {
		guard let viewController = view else { return }

		let errorAlert = UIAlertController.createErrorAlert(message: message)
		viewController.present(errorAlert, animated: true)
	}
}
