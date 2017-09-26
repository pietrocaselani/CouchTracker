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

final class ShowsProgressMocks {
  private init() {}

  static func createWatchedShowsMock() -> [BaseShow] {
    let array = JSONParser.toArray(data: Sync.watched(type: .shows, extended: .full).sampleData)
    return array.map { try! BaseShow(JSON: $0) }
  }

  static func createShowMock(_ showId: String) -> BaseShow? {
    let json = JSONParser.toObject(data: Shows.watchedProgress(showId: showId, hidden: false, specials: false, countSpecials: false).sampleData)
    return BaseShow(JSON: json)
  }

  static func createEpisodeMock(_ showId: String) -> Episode {
    let json = JSONParser.toObject(data: Episodes.summary(showId: showId, season: 1, episode: 1, extended: .full).sampleData)
    return try! Episode(JSON: json)
  }

  final class ShowsProgressRepositoryMock: ShowsProgressRepository {
    private let trakt: TraktProvider

    init(trakt: TraktProvider, cache: AnyCache<Int, NSData>) {
      self.trakt = trakt
    }

    func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]> {
      return trakt.sync.request(.watched(type: .shows, extended: extended)).mapArray(BaseShow.self)
    }

    func fetchShowProgress(update: Bool, showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
      return trakt.shows.request(.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)).mapObject(BaseShow.self)
    }

    func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int, of showId: String, extended: Extended) -> Observable<Episode> {
      return trakt.episodes.request(.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)).mapObject(Episode.self)
    }
  }
}
