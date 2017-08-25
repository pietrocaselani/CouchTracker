/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import UIKit

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
