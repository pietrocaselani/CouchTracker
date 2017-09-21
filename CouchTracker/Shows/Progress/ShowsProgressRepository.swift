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

  init(trakt: TraktProvider) {
    self.trakt = trakt
    let queue = DispatchQueue(label: "showsProgressQueue")
    scheduler = ConcurrentDispatchQueueScheduler(queue: queue)
  }

  func fetchWatchedShows(extended: Extended) -> Observable<[BaseShow]> {
    return trakt.sync.request(.watched(type: .shows, extended: extended)).observeOn(scheduler).mapArray(BaseShow.self)
  }

  func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)
    return trakt.shows.request(target).observeOn(scheduler).mapObject(BaseShow.self)
  }

  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
    return trakt.episodes.request(target).observeOn(scheduler).mapObject(Episode.self)
  }
}
