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

import TraktSwift
import RxSwift

final class ShowsProgressAPIRepository: ShowsProgressRepository {
  private let trakt: TraktProvider
  private let scheduler: SchedulerType
  private let cache: AnyCache<Int, NSData>

  init(trakt: TraktProvider, cache: AnyCache<Int, NSData>) {
    self.trakt = trakt
    self.cache = cache
    let queue = DispatchQueue(label: "showsProgressQueue")
    scheduler = ConcurrentDispatchQueueScheduler(queue: queue)
  }

  func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]> {
    let target = Sync.watched(type: .shows, extended: extended)
    let cacheKey = target.hashValue

    let api = trakt.sync.request(target)
      .observeOn(scheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map { $0.data as NSData }

    return fetchFromCacheOrAPI(api: api, cacheKey: cacheKey, force: update).mapArray(BaseShow.self)
  }

  func fetchShowProgress(update: Bool, showId: String, hidden: Bool,
                         specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)
    let cacheKey = target.hashValue

    let api = trakt.shows.request(target)
      .observeOn(scheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map { $0.data as NSData }

    return fetchFromCacheOrAPI(api: api, cacheKey: cacheKey, force: update).mapObject(BaseShow.self)
  }

  func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
    let cacheKey = target.hashValue

    let api = trakt.episodes.request(target)
      .observeOn(scheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map { $0.data as NSData }

    return fetchFromCacheOrAPI(api: api, cacheKey: cacheKey, force: update).mapObject(Episode.self)
  }

  private func fetchFromCacheOrAPI(api: Observable<NSData>, cacheKey: Int, force update: Bool) -> Observable<NSData> {
    let apiObservable = api.do(onNext: { [unowned self] data in
      _ = self.cache.set(data, for: cacheKey)
    })

    if update {
      return apiObservable
    }

    return cache.get(cacheKey).observeOn(scheduler).ifEmpty(switchTo: apiObservable).subscribeOn(scheduler)
  }
}
