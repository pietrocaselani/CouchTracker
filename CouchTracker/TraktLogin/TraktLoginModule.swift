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

  static func setupModule(loginOutput: TraktLoginOutput) -> BaseView {
    let traktProvider = Environment.instance.trakt

    guard let interactor = TraktLoginService(traktProvider: traktProvider) else {
      fatalError("Tried to create OAuth URL without redirect URL? See Trakt.swift")
    }

    let outputs = CompositeLoginOutput(outputs: [loginOutput, Environment.instance.defaultOutput])

    let view = TraktLoginViewController()
    let presenter = TraktLoginiOSPresenter(view: view, interactor: interactor, output: outputs)
    let policyDecider = TraktTokenPolicyDecider(loginOutput: outputs, traktProvider: traktProvider)

    view.presenter = presenter
    view.policyDecider = policyDecider

    return view
  }
}
