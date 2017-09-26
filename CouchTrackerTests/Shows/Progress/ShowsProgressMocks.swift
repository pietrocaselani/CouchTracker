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
}
