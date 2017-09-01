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

import Foundation
import ObjectMapper

public final class BaseShow: ImmutableMappable, Hashable {
  public let show: Show?
  public let seasons: [BaseSeason]?
  public let lastCollectedAt: Date?
  public let listedAt: Date?
  public let plays: Int?
  public let lastWatchedAt: Date?
  public let aired: Int?
  public let completed: Int?
  public let hiddenSeasons: [Season]?
  public let nextEpisode: Episode?

  public required init(map: Map) throws {
    self.show = try? map.value("show")
    self.seasons = try? map.value("seasons")
    self.lastCollectedAt = try? map.value("last_collected_at", using: TraktDateTransformer.dateTimeTransformer)
    self.listedAt = try? map.value("listed_at", using: TraktDateTransformer.dateTimeTransformer)
    self.plays = try? map.value("plays")
    self.lastWatchedAt = try? map.value("last_watched_at", using: TraktDateTransformer.dateTimeTransformer)
    self.aired = try? map.value("aired")
    self.completed = try? map.value("completed")
    self.hiddenSeasons = try? map.value("hidden_seasons")
    self.nextEpisode = try? map.value("next_episode")
  }

  public var hashValue: Int {
    return 0
  }

  public static func == (lhs: BaseShow, rhs: BaseShow) -> Bool {
    return false
  }

}
