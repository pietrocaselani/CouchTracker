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

final class AppConfigurationsiOSPresenter: AppConfigurationsPresenter {
  private weak var view: AppConfigurationsView!
  private let interactor: AppConfigurationsInteractor
  fileprivate let router: AppConfigurationsRouter
  private let disposeBag = DisposeBag()
  private var options = [AppConfigurationOptions]()

  init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    updateView()
  }

  func optionSelectedAt(index: Int) {
    let option = options[index]
    switch option {
    case .connectToTrakt:
      self.router.showTraktLogin(output: self)
    default: break
    }
  }

  fileprivate func updateView(forced: Bool = false) {
    interactor.fetchLoginState(forced: forced)
      .map { [unowned self] in self.createViewModel($0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] viewModel in
        self.view.showConfigurations(models: viewModel)
        }, onError: { error in
          self.router.showError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }

  private func createViewModel(_ loginState: LoginState) -> [AppConfigurationsViewModel] {
    var configurations = [AppConfigurationViewModel]()

    if case .logged(let user) = loginState {
      configurations.append(AppConfigurationViewModel(title: "Connected".localized, subtitle: user.name))
      options.append(AppConfigurationOptions.connectedToTrakt)
    } else {
      configurations.append(AppConfigurationViewModel(title: "Connect to Trakt".localized, subtitle: nil))
      options.append(AppConfigurationOptions.connectToTrakt)
    }

    return [AppConfigurationsViewModel(title: "Trakt", configurations: configurations)]
  }
}

extension AppConfigurationsiOSPresenter: TraktLoginOutput {
  func loggedInSuccessfully() {
    updateView(forced: true)
  }

  func logInFail(message: String) {
    router.showError(message: message)
  }
}
