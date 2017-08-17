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

protocol ListMoviesRouter: class {

  func configure(view: ListMoviesView)

}

protocol ListMoviesPresenter: class {

  init(view: ListMoviesView, router: ListMoviesRouter, interactor: ListMoviesInteractor)

  func viewDidLoad()

}

protocol ListMoviesView: class {

  var presenter: ListMoviesPresenter! { get set }

  func showEmptyView()

  func show(movies: [MovieViewModel])

  func show(error: String)

}

protocol ListMoviesInteractor: class {

  init(store: ListMoviesStore)

  func fetchMovies() -> Observable<[MovieEntity]>

}

protocol ListMoviesStore: class {

  func fetchMovies() -> Observable<[MovieEntity]>

}

struct MovieEntity {
  let identifier: String
  let title: String
}

extension MovieEntity: Equatable, Hashable {

  static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.title == rhs.title
  }

  var hashValue: Int {
    return identifier.hashValue * title.hashValue
  }
}

struct MovieViewModel {
  let title: String
}

extension MovieViewModel: Equatable, Hashable {

  static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
    return lhs.title == rhs.title
  }

  var hashValue: Int {
    return title.hashValue
  }

}
