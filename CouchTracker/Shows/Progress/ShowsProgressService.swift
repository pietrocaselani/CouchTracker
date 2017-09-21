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

private struct ShowProgress {
  var baseShow: BaseShow?
  var detailShow: BaseShow?
  var episode: Episode?

  fileprivate init(baseShow: BaseShow? = nil, detailShow: BaseShow? = nil, episode: Episode? = nil) {
    self.baseShow = baseShow
    self.detailShow = detailShow
    self.episode = episode
  }
}

final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository

  init(repository: ShowsProgressRepository) {
    self.repository = repository
  }

  func fetchWatchedShowsProgress() -> Observable<ShowProgressEntity> {
    let observable = repository.fetchWatchedShows(extended: .full)

    return observable.flatMap { baseShows -> Observable<BaseShow> in
      return Observable.from(baseShows)
      }.map { baseShow -> ShowProgress in
        return ShowProgress(baseShow: baseShow)
      }.flatMap { showProgress -> Observable<ShowProgress> in
        return self.fetchProgressForShow(showProgress)
      }.flatMap { showProgress -> Observable<ShowProgress> in
        return self.fetchNextEpisodeDetails(showProgress)
      }.flatMap { showProgress -> Observable<ShowProgressEntity> in
        return self.convertToEntityObservable(showProgress)
    }
  }

  private func fetchProgressForShow( _ showProgress: ShowProgress) -> Observable<ShowProgress> {
    guard let showId = showProgress.baseShow?.show?.ids.slug else { return Observable.empty() }
    var showProgress = showProgress

    let observable = repository.fetchShowProgress(showId: showId, hidden: false, specials: false, countSpecials: false)

    return observable.map {
      showProgress.detailShow = $0
      return showProgress
    }
  }

  private func fetchNextEpisodeDetails(_ showProgress: ShowProgress) -> Observable<ShowProgress> {
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

  private func convertToEntityObservable(_ showProgress: ShowProgress) -> Observable<ShowProgressEntity> {
    guard let show = showProgress.baseShow?.show else { return Observable.empty() }

    let showEntity = ShowEntityMapper.entity(for: show)
    let episodeEntity = showProgress.episode.map { EpisodeEntityMapper.episodeProgress(for: $0) }

    let aired = showProgress.detailShow?.aired ?? 0
    let completed = showProgress.detailShow?.completed ?? 0

    let entity = ShowProgressEntity(show: showEntity,
                                    aired: aired,
                                    completed: completed,
                                    nextEpisode: episodeEntity)
    return Observable.just(entity)
  }
}
