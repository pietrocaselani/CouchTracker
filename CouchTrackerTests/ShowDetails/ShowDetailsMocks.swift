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

let showDetailsRepositoryMock = ShowDetailsRepositoryMock(traktProvider: traktProviderMock)

final class ShowDetailsRepositoryErrorMock: ShowDetailsRepository {
  private let error: Error

  init(traktProvider: TraktProvider = traktProviderMock) {
    self.error = NSError(domain: "com.arctouch", code: 120)
  }

  init(traktProvider: TraktProvider = traktProviderMock, error: Error) {
    self.error = error
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return Single.error(error)
  }
}

final class ShowDetailsRepositoryMock: ShowDetailsRepository {
  private let provider: TraktProvider
  init(traktProvider: TraktProvider) {
    self.provider = traktProvider
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return provider.shows.request(.summary(showId: identifier, extended: extended)).mapObject(Show.self).asSingle()
  }
}

final class ShowDetailsInteractorMock: ShowDetailsInteractor {
  private let genreRepository: GenreRepository
  private let repository: ShowDetailsRepository
  private let showId: String

  init(showId: String, repository: ShowDetailsRepository, genreRepository: GenreRepository) {
    self.showId = showId
    self.repository = repository
    self.genreRepository = genreRepository
  }

  func fetchDetailsOfShow() -> Single<ShowEntity> {
    let genresObservable = genreRepository.fetchShowsGenres()
    let showObservable = repository.fetchDetailsOfShow(with: showId, extended: .full).asObservable()

    return Observable.combineLatest(showObservable, genresObservable, resultSelector: { (show, genres) -> ShowEntity in
      let showGenres = genres.filter { genre -> Bool in
        show.genres?.contains(where: { $0 == genre.slug }) ?? false
      }
      return ShowEntityMapper.entity(for: show, with: showGenres)
    }).asSingle()
  }
}

final class ShowDetailsRouterMock: ShowDetailsRouter {
  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
  }
}

final class ShowDetailsViewMock: ShowDetailsView {
  var presenter: ShowDetailsPresenter!
  var invokedShowDetails = false
  var invokedShowDetailsParameters: (details: ShowDetailsViewModel, Void)?

  func show(details: ShowDetailsViewModel) {
    invokedShowDetails = true
    invokedShowDetailsParameters = (details, ())
  }
}

func createTraktShowDetails() -> Show {
  let json = parseToJSONObject(data: Shows.summary(showId: "game-of-thrones", extended: .full).sampleData)
  return try! Show(JSON: json)
}
