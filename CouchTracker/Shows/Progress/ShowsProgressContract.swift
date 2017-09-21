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

protocol ShowsProgressRepository: class {
  init(trakt: TraktProvider)

  func fetchWatchedShows(extended: Extended) -> Observable<[BaseShow]>
  func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow>
  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode>
}

protocol ShowsProgressInteractor: class {
  init(repository: ShowsProgressRepository)

  func fetchWatchedShowsProgress() -> Observable<ShowProgressEntity>
}

protocol ShowsProgressPresenter: class {
  init(view: ShowsProgressView, interactor: ShowsProgressInteractor)

  func viewDidLoad()
}

protocol ShowsProgressView: class {
  var presenter: ShowsProgressPresenter! { get set }

  func showNew(viewModel: ShowProgressViewModel)
  func updateFinished()
}
