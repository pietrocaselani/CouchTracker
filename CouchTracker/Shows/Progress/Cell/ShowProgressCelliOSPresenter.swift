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

final class ShowProgressCelliOSPresenter: ShowProgressCellPresenter {
  private weak var view: ShowProgressCellView?
  private let interactor: ShowProgressCellInteractor
  private let viewModel: WatchedShowViewModel
  private let disposeBag = DisposeBag()

  init(view: ShowProgressCellView, interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel) {
    self.view = view
    self.interactor = interactor
    self.viewModel = viewModel
  }

  func viewWillAppear() {
    view?.show(viewModel: viewModel)

    guard let tmdbId = viewModel.tmdbId else { return }

    interactor.fetchPosterImageURL(for: tmdbId, with: .w185)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] url in
        guard let view = self?.view else { return }

        view.showPosterImage(with: url)
      }).disposed(by: disposeBag)
  }
}
