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

import RxSwift
import Foundation

protocol TraktLoginInteractor: class {
  init?(traktProvider: TraktProvider)

  func fetchLoginURL() -> Single<URL>
}

protocol TraktLoginPresenter: class {
  init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput)

  func viewDidLoad()
}

protocol TraktLoginView: class {
  var presenter: TraktLoginPresenter! { get set }

  func loadLogin(using url: URL)
}

protocol TraktLoginOutput: class {
  func loggedInSuccessfully()
  func logInFail(message: String)
}
