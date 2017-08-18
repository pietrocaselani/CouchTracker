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

final class ListMoviesPresenterImpl: ListMoviesPresenter {

  private weak var view: ListMoviesView?
  private weak var router: ListMoviesRouter?

  private let interactor: ListMoviesInteractor
  private let disposeBag = DisposeBag()

  private var movies = [TrendingMovie]()

  private var currentPage = 0

  init(view: ListMoviesView, router: ListMoviesRouter, interactor: ListMoviesInteractor) {
    self.view = view
    self.router = router
    self.interactor = interactor
  }

  func viewDidLoad() {
    interactor.fetchMovies(page: currentPage, limit: 50)
        .do(onNext: { entities in
          self.movies.removeAll()
          self.movies.append(contentsOf: entities)
        }).map { [unowned self] entities -> [MovieViewModel] in
          self.transformToViewModels(entities: entities)
        }
        .observeOn(MainScheduler.instance)
        .subscribe { [unowned self] event in
          if case .next(let viewModels) = event {
            if viewModels.count == 0 {
              self.view?.showEmptyView()
            } else {
              self.view?.show(movies: viewModels)
            }
          } else if case .error(let error) = event {
            self.view?.show(error: error.localizedDescription)
          } else if self.movies.count == 0 {
            self.view?.showEmptyView()
          }
        }.addDisposableTo(disposeBag)
  }

  func transformToViewModels(entities: [TrendingMovie]) -> [MovieViewModel] {
    return entities.map { entity -> MovieViewModel in
      MovieViewModel(title: entity.movie.title ?? "TBA")
    }
  }
}
