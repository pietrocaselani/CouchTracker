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

protocol MovieDetailsRouter: class {
  func showError(message: String)
}

protocol MovieDetailsPresenter: class {
  init(view: MovieDetailsView, interactor: MovieDetailsInteractor, router: MovieDetailsRouter)

  func viewDidLoad()
}

protocol MovieDetailsView: BaseView {
  var presenter: MovieDetailsPresenter! { get set }

  func show(details: MovieDetailsViewModel)
  func show(images: MovieDetailsImageViewModel)
}

protocol MovieDetailsInteractor: class {
  init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
       imageRepository: ImageRepository, movieIds: MovieIds)

  func fetchDetails() -> Observable<MovieEntity>
  func fetchImages() -> Observable<ImagesEntity>
}

protocol MovieDetailsRepository: class {
  func fetchDetails(movieId: String) -> Observable<Movie>
}
