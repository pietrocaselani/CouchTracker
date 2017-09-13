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
import Foundation

final class MovieEntityMapper {
  private init() {}

  static func entity(for movie: Movie, with genres: [Genre]? = nil) -> MovieEntity {
    return MovieEntity(ids: movie.ids, title: movie.title, genres: genres,
                       tagline: movie.tagline, overview: movie.overview, releaseDate: movie.released)
  }

  static func entity(for trendingMovie: TrendingMovie,
                     with genres: [Genre]? = nil) -> TrendingMovieEntity {
    let movie = entity(for: trendingMovie.movie, with: genres)
    return TrendingMovieEntity(movie: movie)
  }
}
