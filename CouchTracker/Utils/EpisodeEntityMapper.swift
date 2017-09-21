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

final class EpisodeEntityMapper {
  private init() {}

  static func episodeProgress(for episode: Episode) -> EpisodeProgressEntity {
    return EpisodeProgressEntity(ids: episode.ids,
                                 title: episode.title ?? "TBA".localized,
                                 number: episode.number,
                                 season: episode.season,
                                 firstAired: episode.firstAired)
  }
}
