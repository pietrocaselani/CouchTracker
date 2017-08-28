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

final class ListMoviesSearchOutput: SearchResultOutput {
  private weak var view: ListMoviesView?
  private let router: ListMoviesRouter
  private let presenter: ListMoviesPresenterLayer

  init(view: ListMoviesView, router: ListMoviesRouter, presenter: ListMoviesPresenterLayer) {
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

    let movieViewModels = results.map { $0.movie ?? MovieViewModel(title: "") }
      .filter { $0.title.characters.count > 0 }

    view.show(movies: movieViewModels)
  }

  private func fetchTrendingMovies() {
    self.presenter.fetchMovies()
  }
}
