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

final class TraktLoginModule {
  private init() {}

  static func setupModule(traktProvider: TraktProvider, loginOutput: TraktLoginOutput) -> BaseView {
    guard let interactor = TraktLoginService(traktProvider: traktProvider) else {
      fatalError("Tried to create OAuth URL without redirect URL? See Trakt.swift")
    }

    let view = TraktLoginViewController()
    let presenter = TraktLoginiOSPresenter(view: view, interactor: interactor, output: loginOutput)
    let policyDecider = TraktTokenPolicyDecider(loginOutput: loginOutput, traktProvider: traktProvider)

    view.presenter = presenter
    view.policyDecider = policyDecider

    return view
  }
}
