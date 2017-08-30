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

func viewModel(for movie: MovieEntity, defaultTitle: String = "TBA".localized) -> MovieViewModel {
  let image = movie.images.bestImage()
  return MovieViewModel(title: movie.title ?? defaultTitle, imageLink: image?.link)
}

func viewModel(for movie: Movie, defaultTitle: String = "TBA".localized) -> MovieViewModel {
  return MovieViewModel(title: movie.title ?? defaultTitle, imageLink: nil)
}
