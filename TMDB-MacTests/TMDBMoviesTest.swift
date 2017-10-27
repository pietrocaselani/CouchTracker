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
