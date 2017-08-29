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

final class SearchiOSPresenter: SearchPresenter {

  private weak var output: SearchResultOutput?
  private let interactor: SearchInteractor
  private let disposeBag = DisposeBag()

  init(interactor: SearchInteractor, resultOutput: SearchResultOutput) {
    self.interactor = interactor
    self.output = resultOutput
  }

  func searchMovies(query: String) {
    interactor.searchMovies(query: query)
        .map { [unowned self] in
          return self.mapToViewModel($0)
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] viewModels in
          guard let output = self.output else { return }

          guard viewModels.count > 0 else {
            output.handleEmptySearchResult()
            return
          }

          output.handleSearch(results: viewModels)
        }, onError: { [unowned self] error in
          self.output?.handleError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ results: [SearchResult]) -> [SearchResultViewModel] {
    return results.map { SearchResultViewModel(type: $0.type, movie: $0.movie.map { viewModel(for: $0) }) }
  }
}
