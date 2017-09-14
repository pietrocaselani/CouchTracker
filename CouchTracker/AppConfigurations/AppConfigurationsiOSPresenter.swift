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
  private let router: AppConfigurationsRouter
  private let disposeBag = DisposeBag()
  private var options = [AppConfigurationOptions]()

  init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    interactor.traktToken().observeOn(MainScheduler.instance)
      .map { [unowned self] in self.createViewModel($0) }
      .subscribe(onSuccess: { [unowned self] viewModel in
        self.view.showConfigurations(models: viewModel)
      }) { [unowned self] error in
        self.router.showError(message: error.localizedDescription)
      }.disposed(by: disposeBag)
  }

  func optionSelectedAt(index: Int) {
    let option = options[index]
    switch option {
    case .connectToTrakt:
      self.router.showTraktLogin()
    default: break;
    }
  }

  private func createViewModel(_ result: TokenResult) -> [AppConfigurationsViewModel] {
    var configurations = [AppConfigurationViewModel]()

    if case .logged(_, let username) = result {
      configurations.append(AppConfigurationViewModel(title: "Connected".localized, subtitle: username))
      options.append(AppConfigurationOptions.connectedToTrakt)
    } else {
      configurations.append(AppConfigurationViewModel(title: "Connect to Trakt".localized, subtitle: nil))
      options.append(AppConfigurationOptions.connectToTrakt)
    }

    return [AppConfigurationsViewModel(title: "Main".localized, configurations: configurations)]
  }
}
