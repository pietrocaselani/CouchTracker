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

protocol MovieDetailsRouter: class {
  func showError(message: String)
}

protocol MovieDetailsPresenterLayer: class {

  init(view: MovieDetailsView, interactor: MovieDetailsInteractorLayer, router: MovieDetailsRouter)

  func viewDidLoad()
}

protocol MovieDetailsView: BaseView {

  var presenter: MovieDetailsPresenterLayer! { get set }

  func show(details: MovieDetailsViewModel)
}

protocol MovieDetailsInteractorLayer: class {

  init(store: MovieDetailsStoreLayer, genreStore: GenreStoreLayer, movieId: String)

  func fetchDetails() -> Observable<Movie>

  func fetchGenres() -> Observable<[Genre]>
}

protocol MovieDetailsStoreLayer: class {

  func fetchDetails(movieId: String) -> Observable<Movie>
}
