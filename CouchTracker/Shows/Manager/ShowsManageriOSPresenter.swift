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

final class ShowsManageriOSPresenter: ShowsManagerPresenter {
  private weak var view: ShowsManagerView?
  private let router: ShowsManagerRouter
  private let loginObservable: TraktLoginObservable
  private let disposeBag = DisposeBag()
  private let options: [ShowsManagerOption]

  init(view: ShowsManagerView, router: ShowsManagerRouter,
       loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerModulesSetup) {
    self.view = view
    self.router = router
    self.loginObservable = loginObservable
    self.options = moduleSetup.options
  }

  func viewDidLoad() {
    loginObservable.observe()
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] loginState in
        if loginState == .notLogged {
          self.router.showNeedsLogin()
        } else {
          guard let view = self.view else { return }

          let titles = self.options.map { $0.rawValue.localized }

          view.showOptionsSelection(with: titles)
        }
      }).disposed(by: disposeBag)
  }

  func showOption(at index: Int) {
    router.show(option: options[index])
  }
}
