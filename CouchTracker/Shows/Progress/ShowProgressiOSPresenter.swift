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
import TraktSwift

final class ShowsProgressiOSPresenter: ShowsProgressPresenter {
  private weak var view: ShowsProgressView?
  private let interactor: ShowsProgressInteractor
  private let disposeBag = DisposeBag()
  private var entities = [ShowProgressEntity]()

  init(view: ShowsProgressView, interactor: ShowsProgressInteractor) {
    self.view = view
    self.interactor = interactor
  }

  func viewDidLoad() {
    interactor.fetchWatchedShowsProgress()
      .do(onNext: { [unowned self] entity in
        self.entities.append(entity)
      }).map { [unowned self] in self.mapToViewModel($0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] viewModel in
        self.view?.showNew(viewModel: viewModel)
      }, onError: { error in
        print(error)
      }, onCompleted: { [unowned self] in
        self.view?.updateFinished()
      }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ entity: ShowProgressEntity) -> ShowProgressViewModel {
    let status: String

    if let nextEpisode = entity.nextEpisode {
      status = nextEpisode.firstAired?.shortString() ?? entity.show.status?.rawValue.localized ?? "Unknown".localized
    } else {
      status = entity.show.status?.rawValue.localized ?? "Unknown".localized
    }

    return ShowProgressViewModel(title: entity.show.title ?? "TBA".localized,
                                 nextEpisode: entity.nextEpisode?.title,
                                 networkInfo: entity.show.network ?? "Unknown",
                                 status: status,
                                 tmdbId: entity.show.ids.tmdb)
  }
}
