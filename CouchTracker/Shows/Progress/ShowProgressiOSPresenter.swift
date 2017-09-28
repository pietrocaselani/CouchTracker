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

final class ShowsProgressiOSPresenter: ShowsProgressPresenter {
  private weak var view: ShowsProgressView?
  private let interactor: ShowsProgressInteractor
  private let disposeBag = DisposeBag()
  private var originalEntities = [WatchedShowEntity]()
  private var entities = [WatchedShowEntity]()
  private var currentFilter = ShowProgressFilter.none
  private var currentSort = ShowProgressSort.title
  var dataSource: ShowsProgressDataSource

  init(view: ShowsProgressView, interactor: ShowsProgressInteractor, dataSource: ShowsProgressDataSource) {
    self.view = view
    self.interactor = interactor
    self.dataSource = dataSource
  }

  func viewDidLoad() {
    fetchShows(update: false)
  }

  func updateShows() {
    dataSource.update()
    fetchShows(update: true)
  }

  func handleFilter() {
    let sorting = ShowProgressSort.allValues().map { $0.rawValue.localized }
    let filtering = ShowProgressFilter.allValues().map { $0.rawValue.localized }

    let sortIndex = currentSort.index()
    let filterIndex = currentFilter.index()
    view?.showOptions(for: sorting, for: filtering, currentSort: sortIndex, currentFilter: filterIndex)
  }

  func handleDirection() {
    entities.reverse()
    reloadViewModels()
  }

  func changeSort(to index: Int, filter: Int) {
    currentSort = ShowProgressSort.sort(for: index)
    currentFilter = ShowProgressFilter.filter(for: filter)

    entities = originalEntities.filter(currentFilter.filter())

    entities.sort(by: currentSort.comparator())

    reloadViewModels()
  }

  private func reloadViewModels() {
    let sortedViewModels = entities.map { [unowned self] in self.mapToViewModel($0) }

    dataSource.set(viewModels: sortedViewModels)
    view?.reloadList()
  }

  private func fetchShows(update: Bool) {
    interactor.fetchWatchedShowsProgress(update: update)
      .do(onNext: { [unowned self] in
        self.originalEntities.append($0)
        self.entities.append($0)
      }).map { [unowned self] entity in
        return self.mapToViewModel(entity)
      }.observeOn(MainScheduler.instance)
      .do(onNext: { [unowned self] viewModel in
        self.dataSource.add(viewModel: viewModel)
      })
      .subscribe(onNext: { [unowned self] _ in
        self.view?.newViewModelAvailable(at: self.dataSource.viewModelCount() - 1 )
      }, onError: { error in
        print(error)
      }, onCompleted: { [unowned self] in
        guard let view = self.view else { return }

        view.updateFinished()

        if self.dataSource.viewModelCount() == 0 {
          view.showEmptyView()
        }
      }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ entity: WatchedShowEntity) -> WatchedShowViewModel {
    let nextEpisodeTitle = entity.nextEpisode.map { "\($0.season)x\($0.number) \($0.title)" }
    let nextEpisodeDateText = nextEpisodeDate(for: entity)
    let statusText = status(for: entity)

    return WatchedShowViewModel(title: entity.show.title ?? "TBA".localized,
                                nextEpisode: nextEpisodeTitle,
                                nextEpisodeDate: nextEpisodeDateText,
                                status: statusText,
                                tmdbId: entity.show.ids.tmdb)
  }

  private func status(for entity: WatchedShowEntity) -> String {
    let episodesRemaining = entity.aired - entity.completed
    var status = episodesRemaining == 0 ? "" : "episodes remaining".localized(String(episodesRemaining))

    if let nextwork = entity.show.network {
      status = episodesRemaining == 0 ? nextwork : "\(status) \(nextwork)"
    }

    return status
  }

  private func nextEpisodeDate(for entity: WatchedShowEntity) -> String {
    if let nextEpisodeDate = entity.nextEpisode?.firstAired?.shortString() {
      return nextEpisodeDate
    }

    if let showStatus = entity.show.status?.rawValue.localized {
      return showStatus
    }

    return "Unknown".localized
  }
}
