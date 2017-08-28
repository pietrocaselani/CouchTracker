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
import Trakt

final class SearchPresenter: SearchPresenterLayer {
  private weak var view: SearchView?
  private let output: SearchResultOutput
  private let interactor: SearchInteractorLayer
  private let disposeBag = DisposeBag()

  init(view: SearchView, interactor: SearchInteractorLayer, resultOutput: SearchResultOutput) {
    self.view = view
    self.interactor = interactor
    self.output = resultOutput
  }

  func viewDidLoad() {
    view?.showHint(message: "Type a movie name".localized)
  }

  func searchMovies(query: String) {
    interactor.searchMovies(query: query)
        .map { [unowned self] in
          return self.mapToViewModel($0)
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] viewModels in
          guard viewModels.count > 0 else {
            self.output.handleEmptySearchResult()
            return
          }

          self.output.handleSearch(results: viewModels)
        }, onError: { [unowned self] error in
          self.output.handleError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
  }

  func cancelSearch() {
    self.output.searchCancelled()
  }

  private func mapToViewModel(_ results: [SearchResult]) -> [SearchResultViewModel] {
    return results.map { SearchResultViewModel(type: $0.type, movie: $0.movie.map { mapMovieToViewModel($0) }) }
  }
}
