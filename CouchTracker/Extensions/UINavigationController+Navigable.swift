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

extension UINavigationController: Navigable {

  func push(view: BaseView, animated: Bool) {
    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    pushViewController(viewController, animated: animated)
  }
}
