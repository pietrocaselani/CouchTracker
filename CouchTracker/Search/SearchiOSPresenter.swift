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

final class SearchiOSPresenter: SearchPresenter {
  private weak var view: SearchView?
  private let output: SearchResultOutput
  private let interactor: SearchInteractor
  private let disposeBag = DisposeBag()

  init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput) {
    self.view = view
    self.interactor = interactor
    self.output = resultOutput
  }

  func viewDidLoad() {
    view?.showHint(message: "Type a movie name".localized)
  }

  func searchMovies(query: String) {
    interactor.searchMovies(query: query)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] results in
          guard results.count > 0 else {
            self.output.handleEmptySearchResult()
            return
          }

          self.output.handleSearch(results: results)
        }, onError: { [unowned self] error in
          self.output.handleError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
  }

  func cancelSearch() {
    self.output.searchCancelled()
  }
}
