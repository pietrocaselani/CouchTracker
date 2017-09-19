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

final class AppConfigurationsiOSRouter: AppConfigurationsRouter {
  private let viewController: UIViewController
  private let traktProvider: TraktProvider

  init(viewController: UIViewController, traktProvider: TraktProvider) {
    self.viewController = viewController
    self.traktProvider = traktProvider
  }

  func showTraktLogin(output: TraktLoginOutput) {
    guard let navigationController = viewController.navigationController else { return }

    let innerOutput = PopNavigationControllerOutput(viewController: viewController, output: output)

    let loginView = TraktLoginModule.setupModule(traktProvider: traktProvider, loginOutput: innerOutput)

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
  private let delegateOutput: TraktLoginOutput
  private let viewController: UIViewController

  init(viewController: UIViewController, output: TraktLoginOutput) {
    self.delegateOutput = output
    self.viewController = viewController
  }

  func loggedInSuccessfully() {
    popViewController()

    delegateOutput.loggedInSuccessfully()
  }

  func logInFail(message: String) {
    popViewController()

    delegateOutput.logInFail(message: message)
  }

  private func popViewController() {
    viewController.navigationController?.popViewController(animated: true)
  }
}
