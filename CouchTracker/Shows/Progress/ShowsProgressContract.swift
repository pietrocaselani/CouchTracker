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
  init(trakt: TraktProvider, cache: AnyCache<Int, NSData>)

  func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]>
  func fetchShowProgress(update: Bool, showId: String, hidden: Bool,
                         specials: Bool, countSpecials: Bool) -> Observable<BaseShow>
  func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode>
}

protocol ShowsProgressInteractor: class {
  init(repository: ShowsProgressRepository)

  func fetchWatchedShowsProgress(update: Bool) -> Observable<WatchedShowEntity>
}

protocol ShowsProgressPresenter: class {
  var dataSource: ShowsProgressDataSource { get }
  init(view: ShowsProgressView, interactor: ShowsProgressInteractor, dataSource: ShowsProgressDataSource)

  func viewDidLoad()
  func updateShows()
  func handleFilter()
  func handleDirection()
  func changeSort(to index: Int, filter: Int)
}

protocol ShowsProgressView: class {
  var presenter: ShowsProgressPresenter! { get set }

  func newViewModelAvailable(at index: Int)
  func updateFinished()
  func showEmptyView()
  func reloadList()
  func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int)
}

protocol ShowsProgressDataSource: class {
  func add(viewModel: WatchedShowViewModel)
  func viewModelCount() -> Int
  func update()
  func set(viewModels: [WatchedShowViewModel])
}
