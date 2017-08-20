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

final class ListMoviesPresenter: ListMoviesPresenterOutput {

  private weak var view: ListMoviesView?
  private weak var router: ListMoviesRouter?

  private let interactor: ListMoviesInteractorInput
  private let disposeBag = DisposeBag()

  private var movies = [MovieEntity]()

  init(view: ListMoviesView, router: ListMoviesRouter, interactor: ListMoviesInteractorInput) {
    self.view = view
    self.router = router
    self.interactor = interactor
  }

  func viewDidLoad() {
    interactor.fetchMovies()
        .do(onNext: { [unowned self] entities in
          self.movies = entities
        }).map { [unowned self] in self.transformToViewModels(entities: $0) }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { viewModels in
          guard let view = self.view else {
            return
          }

          if viewModels.count == 0 {
            view.showEmptyView()
          } else {
            view.show(movies: viewModels)
          }
        }, onError: { error in
          guard let view = self.view else {
            return
          }

          if let moviesListError = error as? ListMoviesError {
            view.show(error: moviesListError.message)
          } else {
            view.show(error: error.localizedDescription)
          }
        }, onCompleted: {
          if self.movies.count == 0 {
            self.view?.showEmptyView()
          }
        }).disposed(by: disposeBag)
  }

  func transformToViewModels(entities: [MovieEntity]) -> [MovieViewModel] {
    return entities.map { MovieViewModel(title: $0.title) }
  }
}
