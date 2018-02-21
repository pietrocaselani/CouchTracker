import UIKit
import CouchTrackerCore

extension UIAlertController {

	static func createErrorAlert(with title: String = "Error".localized, message: String) -> UIAlertController {
		let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
			errorAlert.dismiss(animated: true, completion: nil)
		}

		errorAlert.addAction(okAction)

		return errorAlert
	}

}
