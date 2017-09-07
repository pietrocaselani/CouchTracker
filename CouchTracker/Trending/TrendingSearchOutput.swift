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
  private let dataSource: TrendingDataSource

  init(view: TrendingView, router: TrendingRouter, presenter: TrendingPresenter, dataSource: TrendingDataSource) {
    self.view = view
    self.router = router
    self.presenter = presenter
    self.dataSource = dataSource
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

    let viewModels = results.flatMap { $0.movie }

    dataSource.viewModels = viewModels
    view.showTrendingsView()
  }

  private func fetchTrendingMovies() {
    self.presenter.viewDidLoad()
  }
}
