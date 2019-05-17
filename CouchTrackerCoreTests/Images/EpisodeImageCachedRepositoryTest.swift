@testable import CouchTrackerCore
import RxTest
import XCTest

final class EpisodeImageCachedRepositoryTest: XCTestCase {
  private var tmdb: TMDBProviderMock!
  private var tvdb: TVDBProviderMock!
  private var configRepository: ConfigurationRepositoryMock!
  private var scheduler: TestSchedulers!

  override func setUp() {
    super.setUp()

    tmdb = createTMDBProviderMock()
    tvdb = createTVDBProviderMock()
    configRepository = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)
    scheduler = TestSchedulers()
  }

  override func tearDown() {
    tmdb = nil
    tvdb = nil
    configRepository = nil
    scheduler = nil
    super.tearDown()
  }

  func testEpisodeImageCachedRepository_fetchEpisodeImages_withDefaultSize() {
    // Given
    let repository = EpisodeImageCachedRepository(tmdb: tmdb, tvdb: tvdb, configurationRepository: configRepository)
    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3_254_641, season: 1, number: 1)

    // When
    let res = scheduler.start {
      repository.fetchEpisodeImages(for: input).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https:/image.tmdb.org/t/p/w300/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")

    let expectedEvents = [Recorded.next(200, expectedURL), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testEpisodeImageCachedRepository_fetchEpisodeImages_witSpecifSize() {
    // Given
    let repository = EpisodeImageCachedRepository(tmdb: tmdb, tvdb: tvdb, configurationRepository: configRepository)
    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3_254_641, season: 1, number: 1)
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

    // When
    let res = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")

    let expectedEvents = [Recorded.next(200, expectedURL), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testEpisodeImageCachedRepository_fetchEpisodeImages_fromCache() {
    // Given
    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3_254_641, season: 1, number: 1)
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

    let url = URL(validURL: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")
    let key = EpisodeImageUtils.cacheKey(episode: input, size: size)
    let cache = [key: url]

    let repository = EpisodeImageCachedRepository(tmdb: tmdb,
                                                  tvdb: tvdb,
                                                  configurationRepository: configRepository,
                                                  cache: cache)
    // When
    let res = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")

    let expectedEvents = [Recorded.next(200, expectedURL), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual((tmdb.episodes as! MoyaProviderMock).requestInvokedCount, 0)
    XCTAssertEqual((tvdb.episodes as! MoyaProviderMock).requestInvokedCount, 0)
  }

  func testEpisodeImageCachedRepository_fetchEpisodeImages_shouldPopulateCache() {
    // Given
    let repository = EpisodeImageCachedRepository(tmdb: tmdb, tvdb: tvdb, configurationRepository: configRepository)
    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3_254_641, season: 1, number: 1)
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

    // When
    let res1 = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    let res2 = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")

    let expectedEvents1 = [Recorded.next(200, expectedURL), Recorded.completed(200)]
    let expectedEvents2 = [Recorded.next(1000, expectedURL), Recorded.completed(1000)]

    XCTAssertEqual(res1.events, expectedEvents1)
    XCTAssertEqual(res2.events, expectedEvents2)
    XCTAssertEqual((tmdb.episodes as! MoyaProviderMock).requestInvokedCount, 1)
    XCTAssertEqual((tvdb.episodes as! MoyaProviderMock).requestInvokedCount, 0)
  }

  func testEpisodeImageCachedRepository_tryTofetchFromTMDBBefore_thenTVDB() {
    // Given
    let tmdb = createTMDBProviderMock(error: TraktError.loginRequired)
    let tvdb = createTVDBProviderMock()
    let configRepository = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)
    let repository = EpisodeImageCachedRepository(tmdb: tmdb, tvdb: tvdb, configurationRepository: configRepository)

    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3_254_641, season: 1, number: 1)
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

    // When
    let res = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https://www.thetvdb.com/banners/episodes/276564/5634087.jpg")

    let expectedEvents = [Recorded.next(200, expectedURL), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual((tmdb.episodes as! MoyaProviderMock).requestInvokedCount, 1)
    XCTAssertEqual((tvdb.episodes as! MoyaProviderMock).requestInvokedCount, 1)
  }

  func testEpisodeImageCachedRepository_whenThereIsNoTVDBId_fetchesFromTMDB() {
    // Given
    let tmdb = createTMDBProviderMock()
    let tvdb = createTVDBProviderMock()
    let configRepository = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)
    let repository = EpisodeImageCachedRepository(tmdb: tmdb, tvdb: tvdb, configurationRepository: configRepository)

    let input = EpisodeImageInputMock(tmdb: 1399, tvdb: nil, season: 1, number: 1)
    let size = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

    // When
    let res = scheduler.start {
      repository.fetchEpisodeImages(for: input, size: size).asObservable()
    }

    // Then
    let expectedURL = URL(validURL: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")

    let expectedEvents = [Recorded.next(200, expectedURL), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual((tmdb.episodes as! MoyaProviderMock).requestInvokedCount, 1)
    XCTAssertEqual((tvdb.episodes as! MoyaProviderMock).requestInvokedCount, 0)
  }
}
