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

import Trakt_Swift

func entity(for show: Show, with genres: [Genre]? = nil) -> ShowEntity {
  return ShowEntity(showIds: show.ids, title: show.title, overview: show.overview,
             genres: genres, status: show.status, firstAired: show.firstAired)
}

func entity(for trendingShow: TrendingShow, with genres: [Genre]? = nil) -> TrendingShowEntity {
  let show = entity(for: trendingShow.show, with: genres)
  return TrendingShowEntity(show: show)
}
