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

final class ShowDetailsService: ShowDetailsInteractor {
  private let showId: String
  private let repository: ShowDetailsRepository
  private let genreRepository: GenreRepository

  init(showId: String, repository: ShowDetailsRepository, genreRepository: GenreRepository) {
    self.showId = showId
    self.repository = repository
    self.genreRepository = genreRepository
  }

  func fetchDetailsOfShow() -> Single<ShowEntity> {
    let genreObservable = genreRepository.fetchShowsGenres()
    let showObservable = repository.fetchDetailsOfShow(with: showId, extended: .full).asObservable()

    return  Observable.combineLatest(showObservable, genreObservable) { (show, genres) -> ShowEntity in
      let showGenres = genres.filter { genre -> Bool in
        return show.genres?.contains(where: { $0 == genre.slug }) ?? false
      }

      return ShowEntityMapper.entity(for: show, with: showGenres)
    }.asSingle()
  }
}
