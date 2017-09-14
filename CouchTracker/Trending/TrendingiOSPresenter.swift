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
import TraktSwift

final class TrendingiOSPresenter: TrendingPresenter {
  private static let limitPerPage = 25

  weak var view: TrendingView?
  var dataSource: TrendingDataSource
  var currentTrendingType = Variable<TrendingType>(.movies)

  private let interactor: TrendingInteractor
  private let disposeBag = DisposeBag()
  private var movies = [TrendingMovieEntity]()
  private var shows = [TrendingShowEntity]()
  private var currentMoviesPage = 0
  private var currentShowsPage = 0
  fileprivate let router: TrendingRouter
  fileprivate var searchResults = [SearchResult]()
  fileprivate var searchState = SearchState.notSearching

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

  fileprivate func loadTrendingMedia(of type: TrendingType) {
    switch type {
    case .movies: fetchMovies()
    case .shows: fetchShows()
    }
  }

  func showDetailsOfTrending(at index: Int) {
    if currentTrendingType.value == .movies {
      showDetailsOfMovie(at: index)
    } else {
      showDetailsOfShow(at: index)
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
    observable.asSingle().observeOn(MainScheduler.instance).subscribe(onSuccess: { [unowned self] in
      self.present(viewModels: $0)
    }) { [unowned self] error in
      guard let moviesListError = error as? TrendingError else {
        self.router.showError(message: error.localizedDescription)
        return
      }

      self.router.showError(message: moviesListError.message)
    }.disposed(by: disposeBag)
  }

  fileprivate func present(viewModels: [TrendingViewModel]) {
    guard let view = view else { return }

    guard viewModels.count > 0 else {
      view.showEmptyView()
      return
    }

    dataSource.viewModels = viewModels

    view.showTrendingsView()
  }

  private func transformToViewModels(entities: [TrendingMovieEntity]) -> [TrendingViewModel] {
    return entities.map { MovieViewModelMapper.viewModel(for: $0.movie) }
  }

  private func transformToViewModels(entities: [TrendingShowEntity]) -> [TrendingViewModel] {
    return entities.map { ShowViewModelMapper.viewModel(for: $0.show) }
  }

  private func showDetailsOfMovie(at index: Int) {
    let movieEntity: MovieEntity
    if searchState == .searching {
      guard let movie = searchResults[index].movie else { return }
      movieEntity = MovieEntityMapper.entity(for: movie)
    } else {
      movieEntity = movies[index].movie
    }

    router.showDetails(of: movieEntity)
  }

  private func showDetailsOfShow(at index: Int) {
    let showEntity: ShowEntity
    if searchState == .searching {
      guard let show = searchResults[index].show else { return }
      showEntity = ShowEntityMapper.entity(for: show)
    } else {
      showEntity = shows[index].show
    }
    router.showDetails(of: showEntity)
  }
}

extension TrendingiOSPresenter: SearchResultOutput {
  func searchChangedTo(state: SearchState) {
    searchState = state

    if state == .notSearching {
      searchResults.removeAll()
      loadTrendingMedia(of: currentTrendingType.value)
    }
  }

  func handleEmptySearchResult() {
    view?.showEmptyView()
  }

  func handleSearch(results: [SearchResult]) {
    searchResults = results

    let viewModels = currentTrendingType.value == .movies ?
      mapMoviesToViewModels(results) : mapShowsToViewModels(results)

    present(viewModels: viewModels)
  }

  func handleError(message: String) {
    router.showError(message: message)
  }

  private func mapMoviesToViewModels(_ results: [SearchResult]) -> [TrendingViewModel] {
    return results.flatMap { result -> TrendingViewModel? in
      guard let movie = result.movie else { return nil }
      return MovieViewModelMapper.viewModel(for: movie)
    }
  }

  private func mapShowsToViewModels(_ results: [SearchResult]) -> [TrendingViewModel] {
    return results.flatMap { result -> TrendingViewModel? in
      guard let show = result.show else { return nil }
      return ShowViewModelMapper.viewModel(for: show)
    }
  }
}
