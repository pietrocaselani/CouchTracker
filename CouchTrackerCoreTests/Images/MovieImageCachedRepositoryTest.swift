@testable import CouchTrackerCore
import RxTest
import XCTest

final class MovieImageCachedRepositoryTest: XCTestCase {
  private var tmdb: TMDBProviderMock!
  private var configRepository: ConfigurationRepositoryMock!
  private var scheduler: TestSchedulers!

  override func setUp() {
    super.setUp()

    tmdb = createTMDBProviderMock()
    configRepository = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)
    scheduler = TestSchedulers()
  }

  override func tearDown() {
    tmdb = nil
    configRepository = nil
    scheduler = nil
    super.tearDown()
  }

  private func createImagesMock(backdropSize: String, posterSize: String) -> ImagesEntity {
    var link = "https:/image.tmdb.org/t/p/\(backdropSize)/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
    let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)

    link = "https:/image.tmdb.org/t/p/\(posterSize)/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
    let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

    return ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())
  }

  func testMovieImageCachedRepository_fetchMovieImages_withDefaultSize() {
    // Given
    let repository = MovieImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res = scheduler.start {
      repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).asObservable()
    }

    // Then
    let images = createImagesMock(backdropSize: "w300", posterSize: "w342")

    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testMovieImageCachedRepository_fetchMovieImages_witSpecifSize() {
    // Given
    let repository = MovieImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res = scheduler.start {
      repository.fetchMovieImages(for: 550, posterSize: .w92, backdropSize: .w1280).asObservable()
    }

    // Then
    let images = createImagesMock(backdropSize: "w1280", posterSize: "w92")

    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testMovieImageCachedRepository_fetchMovieImages_fromCache() {
    // Given
    let images = createImagesMock(backdropSize: "w1280", posterSize: "w92")

    let key = TMDBImageUtils.cacheKey(entityId: 550, posterSize: .w92, backdropSize: .w1280)
    let cache = [key: images]

    let repository = MovieImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository, cache: cache)

    // When
    let res = scheduler.start {
      repository.fetchMovieImages(for: 550, posterSize: .w92, backdropSize: .w1280).asObservable()
    }

    // Then
    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual((tmdb.movies as! MoyaProviderMock).requestInvokedCount, 0)
  }

  func testMovieImageCachedRepository_fetchMovieImages_shouldPopulateCache() {
    // Given
    let repository = MovieImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res1 = scheduler.start {
      repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).asObservable()
    }

    let res2 = scheduler.start {
      repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).asObservable()
    }

    // Then
    let images = createImagesMock(backdropSize: "w300", posterSize: "w342")

    let expectedEvents1 = [Recorded.next(200, images), Recorded.completed(200)]
    let expectedEvents2 = [Recorded.next(1000, images), Recorded.completed(1000)]

    XCTAssertEqual(res1.events, expectedEvents1)
    XCTAssertEqual(res2.events, expectedEvents2)
    XCTAssertEqual((tmdb.movies as! MoyaProviderMock).requestInvokedCount, 1)
  }
}
