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

protocol ShowDetailsRepository: class {
  init(traktProvider: TraktProvider)

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

protocol ShowDetailsInteractor: class {
  init(showIds: ShowIds, repository: ShowDetailsRepository,
       genreRepository: GenreRepository, imageRepository: ImageRepository)

  func fetchDetailsOfShow() -> Single<ShowEntity>
  func fetchImages() -> Single<ImagesEntity>
}

protocol ShowDetailsPresenter: class {
  init(view: ShowDetailsView, router: ShowDetailsRouter, interactor: ShowDetailsInteractor)

  func viewDidLoad()
}

protocol ShowDetailsRouter: class {
  func showError(message: String)
}

protocol ShowDetailsView: class {
  var presenter: ShowDetailsPresenter! { get set }

  func show(details: ShowDetailsViewModel)
}
