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
  private static let limitPerPage = 25

  weak var view: TrendingView?
  var dataSource: TrendingDataSource
  var currentTrendingType = Variable<TrendingType>(.movies)

  private let interactor: TrendingInteractor
  private let router: TrendingRouter
  private let disposeBag = DisposeBag()
  private var movies = [TrendingMovieEntity]()
  private var shows = [TrendingShowEntity]()
  private var currentMoviesPage = 0
  private var currentShowsPage = 0

  init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter, dataSource: TrendingDataSource) {
    self.view = view
    self.interactor = interactor
    self.router = router
    self.dataSource = dataSource
  }

  func viewDidLoad() {
    currentTrendingType.asObservable().subscribe(onNext: { [unowned self] newType in
      self.loadTrendingMedia(of: newType)
    }).disposed(by: disposeBag)
  }

  private func loadTrendingMedia(of type: TrendingType) {
    switch type {
    case .movies: fetchMovies()
    case .shows: fetchShows()
    }
  }

  func showDetailsOfTrending(at index: Int) {
    if currentTrendingType.value == .movies {
      showDetailsOfMovie(at: index)
    }
  }

  private func fetchMovies() {
    let observable = interactor.fetchMovies(page: currentMoviesPage, limit: TrendingiOSPresenter.limitPerPage)
      .do(onNext: { [unowned self] in
        self.movies = $0
      }).map { [unowned self] in self.transformToViewModels(entities: $0) }

    subscribe(on: observable, for: .movies)
  }

  private func fetchShows() {
    let observable = interactor.fetchShows(page: currentShowsPage, limit: TrendingiOSPresenter.limitPerPage)
      .do(onNext: { [unowned self] in
        self.shows = $0
      }).map { [unowned self] in self.transformToViewModels(entities: $0) }

    subscribe(on: observable, for: .shows)
  }

  private func subscribe(on observable: Observable<[TrendingViewModel]>, for type: TrendingType) {
    observable.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] in
      guard let view = self.view else { return }

      guard $0.count > 0 else {
        view.showEmptyView()
        return
      }

      self.dataSource.viewModels = $0

      view.showTrendingsView()
      }, onError: { [unowned self] in
        guard let moviesListError = $0 as? TrendingError else {
          self.router.showError(message: $0.localizedDescription)
          return
        }

        self.router.showError(message: moviesListError.message)
      }, onCompleted: { [unowned self] in
        guard let view = self.view else { return }

        let viewModelsCount = type == .movies ? self.movies.count : self.shows.count

        guard viewModelsCount == 0 else { return }

        view.showEmptyView()
    }).disposed(by: disposeBag)
  }

  private func transformToViewModels(entities: [TrendingMovieEntity]) -> [TrendingViewModel] {
    return entities.map { MovieViewModelMapper.viewModel(for: $0.movie) }
  }

  private func transformToViewModels(entities: [TrendingShowEntity]) -> [TrendingViewModel] {
    return entities.map { ShowViewModelMapper.viewModel(for: $0.show) }
  }

  private func showDetailsOfMovie(at index: Int) {
    router.showDetails(of: movies[index])
  }
}
