@testable import CouchTrackerCore
import RxTest
import TMDBSwift
import XCTest

final class ConfigurationCachedRepositoryTests: XCTestCase {
  func testConfigurationCachedRepository_fetchFromCache_whenCacheIsAvailable() {
    // Given
    let tmdb = TMDBProviderMock()
    let repository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let scheduler = TestSchedulers()

    // When
    let observer1 = scheduler.start { repository.fetchConfiguration() }
    let observer2 = scheduler.start { repository.fetchConfiguration() }

    // Then
    let mockConfig = Configuration.mockDefaultConfiguration()
    let expectedEvents1 = [Recorded.next(200, mockConfig),
                           Recorded.completed(200)]
    let expectedEvents2 = [Recorded.next(1000, mockConfig),
                           Recorded.completed(1000)]

    XCTAssertEqual(observer1.events, expectedEvents1)
    XCTAssertEqual(observer2.events, expectedEvents2)

    let mockProvider = tmdb.configuration as! MoyaProviderMock
    XCTAssertEqual(mockProvider.requestInvokedCount, 1)
  }
}
