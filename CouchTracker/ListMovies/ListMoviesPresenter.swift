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

final class ListMoviesPresenter: ListMoviesPresenterLayer {

  weak var view: ListMoviesView?
  let router: ListMoviesRouter

  private let interactor: ListMoviesInteractorLayer
  private let disposeBag = DisposeBag()

  private var movies = [TrendingMovie]()

  private var currentPage = 0

  init(view: ListMoviesView, interactor: ListMoviesInteractorLayer, router: ListMoviesRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  func fetchMovies() {
    interactor.fetchMovies(page: currentPage, limit: 50)
        .do(onNext: { [unowned self] entities in
          self.movies = entities
        }).map { [unowned self] in self.transformToViewModels(entities: $0) }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { viewModels in
          guard let view = self.view else {
            return
          }

          guard viewModels.count > 0 else {
            view.showEmptyView()
            return
          }

          view.show(movies: viewModels)
        }, onError: { [unowned self] error in
          guard let moviesListError = error as? ListMoviesError else {
            self.router.showError(message: error.localizedDescription)
            return
          }

          self.router.showError(message: moviesListError.message)
        }, onCompleted: {
          guard self.movies.count == 0 else { return }
          self.view?.showEmptyView()
        }).disposed(by: disposeBag)
  }

  func showDetailsOfMovie(at index: Int) {
    router.showDetails(of: movies[index])
  }

  private func transformToViewModels(entities: [TrendingMovie]) -> [MovieViewModel] {
    return entities.map { mapMovieToViewModel($0.movie) }
  }
}
