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

  func loadView() -> BaseView
}

protocol MovieDetailsPresenterOutput: class {

  init(view: MovieDetailsView, router: MovieDetailsRouter, interactor: MovieDetailsInteractorInput, movieId: String)

  func viewDidLoad()
}

protocol MovieDetailsView: BaseView {

  var presenter: MovieDetailsPresenterOutput! { get set }

  func show(details: MovieDetailsViewModel)
  func show(error: String)
}

protocol MovieDetailsInteractorInput: class {

  init(store: MovieDetailsStoreInput)

  func fetchDetails(movieId: String) -> Observable<Movie>

}

protocol MovieDetailsStoreInput: class {

  func fetchDetails(movieId: String) -> Observable<Movie>

}