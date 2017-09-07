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

final class TrendingCelliOSPresenter: TrendingCellPresenter {
  private weak var view: TrendingCellView?
  private let interactor: TrendingCellInteractor
  private let viewModel: TrendingViewModel
  private let disposeBag = DisposeBag()

  init(view: TrendingCellView, interactor: TrendingCellInteractor, viewModel: TrendingViewModel) {
    self.view = view
    self.interactor = interactor
    self.viewModel = viewModel
  }

  func viewWillAppear() {
    view?.show(viewModel: TrendingCellViewModel(title: viewModel.title))

    guard let trendingType = viewModel.type else { return }

    interactor.fetchPosterImageURL(of: trendingType, with: .w185)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] imageURL in
        guard let view = self.view else { return }

        view.showPosterImage(with: imageURL)
      }).disposed(by: disposeBag)
  }
}
