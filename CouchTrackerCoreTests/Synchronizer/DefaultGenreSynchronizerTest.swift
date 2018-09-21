@testable import CouchTrackerCore
import TraktSwift

import Nimble
import RxTest
import XCTest

final class DefaultGenreSynchronizerTest: XCTestCase {
  private var synchronizer: DefaultGenreSynchronizer!
  private var schedulers: TestSchedulers!
  private var trakt: TraktProviderMock!
  private var holder: GenreDataSourceMock!

  override func tearDown() {
    synchronizer = nil
    schedulers = nil
    trakt = nil
    holder = nil

    super.tearDown()
  }

  private func setupMock(for type: GenreType) {
    schedulers = TestSchedulers()
    trakt = TraktProviderMock()
    holder = GenreDataSourceMock(type: type)

    synchronizer = DefaultGenreSynchronizer(trakt: trakt, holder: holder, schedulers: schedulers)
  }

  func testSyncMovies_shouldHitTheAPI_and_dataHolder() {
    // Given
    setupMock(for: .movies)

    // When
    let res = schedulers.start { self.synchronizer.syncMoviesGenres().asObservable() }

    // Then
    let expectedGenres = TraktEntitiesMock.createMoviesGenresMock()
    let expectedEvents = [Recorded.next(201, expectedGenres), Recorded.completed(202)]
    XCTAssertEqual(res.events, expectedEvents)
    XCTAssertEqual(holder.fetchGenresInvokedCount, 0)
    XCTAssertEqual(holder.saveGenresInvokedCount, 1)
    XCTAssertEqual(holder.saveGenresParameter, expectedGenres)
    XCTAssertEqual((trakt.genres as! MoyaProviderMock).requestInvokedCount, 1)
  }

  func testSyncShows_shouldHitTheAPI_and_dataHolder() {
    XCTFail("Not implemented")
  }
}
