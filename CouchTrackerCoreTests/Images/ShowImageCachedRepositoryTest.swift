@testable import CouchTrackerCore
import RxTest
import XCTest

final class ShowImageCachedRepositoryTest: XCTestCase {
  private var tmdb: TMDBProviderMock!
  private var configRepository: ConfigurationRepositoryMock!
  private var scheduler: TestSchedulers!

  override func setUp() {
    tmdb = createTMDBProviderMock()
    configRepository = ConfigurationRepositoryMock(tmdbProvider: tmdb)
    scheduler = TestSchedulers()
    super.setUp()
  }

  override func tearDown() {
    tmdb = nil
    configRepository = nil
    scheduler = nil
    super.tearDown()
  }

  private func createImagesMock(posterSize: String, backdropSize: String) -> ImagesEntity {
    var link = "https:/image.tmdb.org/t/p/\(backdropSize)/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"
    let backdrop = ImageEntity(link: link, width: 1920, height: 1080, iso6391: nil, aspectRatio: 1.777777777777778, voteAverage: 5.396825396825397, voteCount: 6)

    link = "https:/image.tmdb.org/t/p/\(posterSize)/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
    let poster = ImageEntity(link: link, width: 2000, height: 3000, iso6391: "en", aspectRatio: 0.6666666666666666, voteAverage: 5.522, voteCount: 6)

    return ImagesEntity(identifier: 1409, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())
  }

  func testShowImageCachedRepository_fetchShowImages_withDefaultSizes() {
    // Given
    let repository = ShowImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res = scheduler.start {
      repository.fetchShowImages(for: 1409, posterSize: nil, backdropSize: nil).asObservable()
    }

    // Then
    let images = createImagesMock(posterSize: "w342", backdropSize: "w300")

    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testShowImageCachedRepository_fetchShowImages_witSpecifSize() {
    // Given
    let repository = ShowImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res = scheduler.start {
      repository.fetchShowImages(for: 550, posterSize: .w92, backdropSize: .w1280).asObservable()
    }

    // Then
    let images = createImagesMock(posterSize: "w92", backdropSize: "w1280")

    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testShowImageCachedRepository_fetchShowImages_fromCache() {
    // Given
    let images = createImagesMock(posterSize: "w92", backdropSize: "w1280")

    let key = TMDBImageUtils.cacheKey(entityId: 550, posterSize: .w92, backdropSize: .w1280)
    let cache = [key: images]

    let repository = ShowImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository, cache: cache)

    // When
    let res = scheduler.start {
      repository.fetchShowImages(for: 550, posterSize: .w92, backdropSize: .w1280).asObservable()
    }

    // Then
    let expectedEvents = [Recorded.next(200, images), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual((tmdb.shows as! MoyaProviderMock).requestInvokedCount, 0)
  }

  func testShowImageCachedRepository_fetchShowImages_shouldPopulateCache() {
    // Given
    let repository = ShowImageCachedRepository(tmdb: tmdb, configurationRepository: configRepository)

    // When
    let res1 = scheduler.start {
      repository.fetchShowImages(for: 550, posterSize: nil, backdropSize: nil).asObservable()
    }

    let res2 = scheduler.start {
      repository.fetchShowImages(for: 550, posterSize: nil, backdropSize: nil).asObservable()
    }

    // Then
    let images = createImagesMock(posterSize: "w342", backdropSize: "w300")

    let expectedEvents1 = [Recorded.next(200, images), Recorded.completed(200)]
    let expectedEvents2 = [Recorded.next(1000, images), Recorded.completed(1000)]

    XCTAssertEqual(res1.events, expectedEvents1)
    XCTAssertEqual(res2.events, expectedEvents2)
    XCTAssertEqual((tmdb.shows as! MoyaProviderMock).requestInvokedCount, 1)
  }
}
