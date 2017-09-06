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

extension ShowIds {
  func tmdbModelType() -> TrendingViewModelType? {
    var type: TrendingViewModelType? = nil
    if let tmdbId = self.tmdb {
      type = TrendingViewModelType.show(tmdbShowId: tmdbId)
    }
    return type
  }
}

func viewModel(for show: ShowEntity, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
  return TrendingViewModel(title: show.title ?? defaultTitle, type: show.showIds.tmdbModelType())
}

func viewModel(for show: Show, defaultTitle: String = "TBA".localized) -> TrendingViewModel {
  return TrendingViewModel(title: show.title ?? defaultTitle, type: show.ids.tmdbModelType())
}
