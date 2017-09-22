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

enum ShowsManagerOption: String {
  case progress
  case now
}

protocol ShowsManagerRouter: class {
  func showNeedsLogin()
  func show(option: ShowsManagerOption)
}

protocol ShowsManagerPresenter: class {
  init(view: ShowsManagerView, router: ShowsManagerRouter,
       loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerModulesSetup)

  func viewDidLoad()
  func showOption(at index: Int)
}

protocol ShowsManagerView: class {
  var presenter: ShowsManagerPresenter! { get set }

  func showOptionsSelection(with titles: [String])
}

protocol ShowsManagerModulesSetup: class {
  var options: [ShowsManagerOption] { get }
}
