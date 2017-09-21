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

final class TraktLoginiOSPresenter: TraktLoginPresenter {
  private weak var view: TraktLoginView?
  private let interactor: TraktLoginInteractor
  private let output: TraktLoginOutput
  private let disposeBag = DisposeBag()

  init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput) {
    self.view = view
    self.interactor = interactor
    self.output = output
  }

  func viewDidLoad() {
    interactor.fetchLoginURL()
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [unowned self] url in
        guard let view = self.view else { return }
        view.loadLogin(using: url)
      }) { [unowned self] error in
        self.output.logInFail(message: error.localizedDescription)
      }.disposed(by: disposeBag)
  }
}
