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

import Trakt_Swift

final class TrendingSearchOutput: SearchResultOutput {
  private weak var view: TrendingView?
  private let router: TrendingRouter
  private let presenter: TrendingPresenter

  init(view: TrendingView, router: TrendingRouter, presenter: TrendingPresenter) {
    self.view = view
    self.router = router
    self.presenter = presenter
  }

  func handleEmptySearchResult() {
    view?.showEmptyView()
  }

  func handleSearch(results: [SearchResultViewModel]) {
    updateMovies(with: results)
  }

  func handleError(message: String) {
    router.showError(message: message)
  }

  func searchCancelled() {
    fetchTrendingMovies()
  }

  private func updateMovies(with results: [SearchResultViewModel]) {
    guard let view = view else { return }

    view.show(trending: results.flatMap { $0.movie })
  }

  private func fetchTrendingMovies() {
    self.presenter.fetchTrending(of: .movies)
  }
}
