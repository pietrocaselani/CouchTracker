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

final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository

  init(repository: ShowsProgressRepository) {
    self.repository = repository
  }

  func fetchWatchedShowsProgress() -> Observable<WatchedShowEntity> {
    return repository.fetchWatchedShows(extended: .full)
      .flatMap { Observable.from($0) }
      .map { WatchedShowBuilder(baseShow: $0) }
      .flatMap { [unowned self] in self.fetchProgressForShow($0) }
      .flatMap { [unowned self] in self.fetchNextEpisodeDetails($0) }
      .flatMap { [unowned self] in self.convertToEntityObservable($0) }
  }

  private func fetchProgressForShow( _ showProgress: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let showId = showProgress.baseShow?.show?.ids.slug else { return Observable.empty() }
    var showProgress = showProgress

    let observable = repository.fetchShowProgress(showId: showId, hidden: false, specials: false, countSpecials: false)

    return observable.map {
      showProgress.detailShow = $0
      return showProgress
    }
  }

  private func fetchNextEpisodeDetails(_ showProgress: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let showId = showProgress.baseShow?.show?.ids.slug else { return Observable.empty() }

    guard let episode = showProgress.detailShow?.nextEpisode else { return Observable.just(showProgress) }
    var showProgress = showProgress

    let observable = repository.fetchDetailsOf(episodeNumber: episode.number,
                                               on: episode.season, of: showId, extended: .full)

    return observable.map {
      showProgress.episode = $0
      return showProgress
    }
  }

  private func convertToEntityObservable(_ showProgress: WatchedShowBuilder) -> Observable<WatchedShowEntity> {
    guard let show = showProgress.baseShow?.show else { return Observable.empty() }

    let showEntity = ShowEntityMapper.entity(for: show)
    let episodeEntity = showProgress.episode.map { EpisodeEntityMapper.entity(for: $0) }

    let aired = showProgress.detailShow?.aired ?? 0
    let completed = showProgress.detailShow?.completed ?? 0

    let entity = WatchedShowEntity(show: showEntity,
                                    aired: aired,
                                    completed: completed,
                                    nextEpisode: episodeEntity)
    return Observable.just(entity)
  }
}

private struct WatchedShowBuilder {
  var baseShow: BaseShow?
  var detailShow: BaseShow?
  var episode: Episode?

  fileprivate init(baseShow: BaseShow? = nil, detailShow: BaseShow? = nil, episode: Episode? = nil) {
    self.baseShow = baseShow
    self.detailShow = detailShow
    self.episode = episode
  }
}
