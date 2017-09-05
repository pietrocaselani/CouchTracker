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
import Foundation

func entity(for movie: Movie, with images: ImagesEntity, genres: [Genre]? = nil) -> MovieEntity {
  return MovieEntity(ids: movie.ids, title: movie.title, images: images, genres: genres,
                     tagline: movie.tagline, overview: movie.overview, releaseDate: movie.released)
}

func entity(for trendingMovie: TrendingMovie,
            with images: ImagesEntity, genres: [Genre]? = nil) -> TrendingMovieEntity {
  let movie = entity(for: trendingMovie.movie, with: images, genres: genres)
  return TrendingMovieEntity(movie: movie)
}
