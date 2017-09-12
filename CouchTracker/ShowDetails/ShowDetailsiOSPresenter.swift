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
import Trakt_Swift

final class ShowDetailsiOSPresenter: ShowDetailsPresenter {
  private weak var view: ShowDetailsView!
  private let router: ShowDetailsRouter
  private let interactor: ShowDetailsInteractor
  private let disposeBag = DisposeBag()

  init(view: ShowDetailsView, router: ShowDetailsRouter, interactor: ShowDetailsInteractor) {
    self.view = view
    self.router = router
    self.interactor = interactor
  }

  func viewDidLoad() {
    interactor.fetchDetailsOfShow().map { [unowned self] in self.mapToViewModel($0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [unowned self] viewModel in
        self.view.show(details: viewModel)
      }) { [unowned self] error in
        self.router.showError(message: error.localizedDescription)
    }.disposed(by: disposeBag)
  }

  private func mapToViewModel(_ show: ShowEntity) -> ShowDetailsViewModel {
    let firstAired = show.firstAired?.parse() ?? "Unknown".localized
    let genres = show.genres?.map { $0.name }.joined(separator: " | ")

    return ShowDetailsViewModel(title: show.title ?? "TBA".localized,
                                overview: show.overview ?? "",
                                network: show.network ?? "Unknown".localized,
                                genres: genres ?? "",
                                firstAired: firstAired)
  }
}
