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

import XCTest

final class TMDBMoviesTest: XCTestCase {

  private let tmdb = TMDB(apiKey: "my_awesome_api_key")

  func testTMDBMovies_images_toJSONToModel() {
    let images = createMovieImagesMock()

    XCTAssertEqual(images.identifier, 550)
  }

  func testTMDBMovies_imagesPath_buildCorrect() {
    let path = Movies.images(movieId: 56).path

    XCTAssertEqual(path, "movie/56/images")
  }
}
