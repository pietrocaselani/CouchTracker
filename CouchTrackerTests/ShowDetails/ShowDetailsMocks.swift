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

  init(traktProvider: TraktProvider) {
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
