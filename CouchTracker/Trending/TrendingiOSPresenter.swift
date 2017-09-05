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
import Trakt_Swift

final class TrendingiOSPresenter: TrendingPresenter {
  weak var view: TrendingView?
  private let interactor: TrendingInteractor
  private let router: TrendingRouter
  private let disposeBag = DisposeBag()
  private var movies = [TrendingMovieEntity]()
  private var currentPage = 0

  init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  func fetchTrending(of type: TrendingType) {
    if type == .movies {
      fetchMovies()
    }
  }

  func showDetailsOfTrending(at index: Int) {
  }

  func showDetailsOfMovie(at index: Int) {
    router.showDetails(of: movies[index])
  }

  private func fetchMovies() {
    interactor.fetchMovies(page: currentPage, limit: 25)
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

        view.show(trending: viewModels)
      }, onError: { [unowned self] error in
        guard let moviesListError = error as? TrendingError else {
          self.router.showError(message: error.localizedDescription)
          return
        }

        self.router.showError(message: moviesListError.message)
        }, onCompleted: {
          guard self.movies.count == 0 else { return }
          self.view?.showEmptyView()
      }).disposed(by: disposeBag)
  }

  private func transformToViewModels(entities: [TrendingMovieEntity]) -> [TrendingViewModel] {
    return entities.map { viewModel(for: $0.movie) }
  }
}
