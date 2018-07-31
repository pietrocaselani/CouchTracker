@testable import CouchTrackerCore
import TraktSwift
import XCTest

final class ShowProgressFilterTest: XCTestCase {
  func testShowProgressFilter_returnAllValues() {
    XCTAssertEqual(ShowProgressFilter.allValues(), [ShowProgressFilter.none, ShowProgressFilter.watched, ShowProgressFilter.returning, ShowProgressFilter.returningWatched])
  }

  func testShowProgressFilter_returnsFilterForIndex() {
    XCTAssertEqual(ShowProgressFilter.filter(for: 0), ShowProgressFilter.none)
    XCTAssertEqual(ShowProgressFilter.filter(for: 1), ShowProgressFilter.watched)
    XCTAssertEqual(ShowProgressFilter.filter(for: 2), ShowProgressFilter.returning)
    XCTAssertEqual(ShowProgressFilter.filter(for: 3), ShowProgressFilter.returningWatched)
    XCTAssertEqual(ShowProgressFilter.filter(for: -1), ShowProgressFilter.none)
    XCTAssertEqual(ShowProgressFilter.filter(for: 4), ShowProgressFilter.none)
  }

  func testShowProgressFilter_returnsIndexForFilter() {
    XCTAssertEqual(ShowProgressFilter.none.index(), 0)
    XCTAssertEqual(ShowProgressFilter.watched.index(), 1)
    XCTAssertEqual(ShowProgressFilter.returning.index(), 2)
    XCTAssertEqual(ShowProgressFilter.returningWatched.index(), 3)
  }

  func testShowProgressFilter_filterNone() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()
    let lastWatched = Date()

    let completedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let nonCompletedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 8, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let cancelledShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.canceled, firstAired: nil)

    let endedShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.ended, firstAired: nil)

    let inDevelopmentShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.inDevelopment, firstAired: nil)

    let returningShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.returning, firstAired: nil)

    let cancelledWatchedShow = WatchedShowEntity(show: cancelledShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let endedWatchedShow = WatchedShowEntity(show: endedShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let inDevelopmentWatchedShow = WatchedShowEntity(show: inDevelopmentShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let returningWatchedShow = WatchedShowEntity(show: returningShow, aired: 11, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    // When
    let shows = [completedWatchedShow, nonCompletedWatchedShow, cancelledWatchedShow, endedWatchedShow, inDevelopmentWatchedShow, returningWatchedShow]

    let filter = ShowProgressFilter.none.filter()

    let filteredShows = shows.filter(filter)

    // Then
    let expectedShows = [completedWatchedShow, nonCompletedWatchedShow, cancelledWatchedShow, endedWatchedShow, inDevelopmentWatchedShow, returningWatchedShow]

    XCTAssertEqual(filteredShows, expectedShows)
  }

  func testShowProgressFilter_filterWatched() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()
    let lastWatched = Date()

    let completedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let nonCompletedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 8, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let cancelledShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.canceled, firstAired: nil)

    let endedShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.ended, firstAired: nil)

    let inDevelopmentShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.inDevelopment, firstAired: nil)

    let returningShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.returning, firstAired: nil)

    let cancelledWatchedShow = WatchedShowEntity(show: cancelledShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let endedWatchedShow = WatchedShowEntity(show: endedShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let inDevelopmentWatchedShow = WatchedShowEntity(show: inDevelopmentShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let returningWatchedShow = WatchedShowEntity(show: returningShow, aired: 11, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    // When
    let shows = [completedWatchedShow, nonCompletedWatchedShow, cancelledWatchedShow, endedWatchedShow, inDevelopmentWatchedShow, returningWatchedShow]

    let filter = ShowProgressFilter.watched.filter()

    let filteredShows = shows.filter(filter)

    // Then
    let expectedShows = [nonCompletedWatchedShow, returningWatchedShow]

    XCTAssertEqual(filteredShows, expectedShows)
  }

  func testShowProgressFilter_filterReturning() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()
    let lastWatched = Date()

    let completedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let nonCompletedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 8, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let cancelledShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.canceled, firstAired: nil)

    let endedShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.ended, firstAired: nil)

    let inDevelopmentShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.inDevelopment, firstAired: nil)

    let returningShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.returning, firstAired: nil)

    let cancelledWatchedShow = WatchedShowEntity(show: cancelledShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let endedWatchedShow = WatchedShowEntity(show: endedShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let inDevelopmentWatchedShow = WatchedShowEntity(show: inDevelopmentShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let returningWatchedShow = WatchedShowEntity(show: returningShow, aired: 11, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    // When
    let shows = [completedWatchedShow, nonCompletedWatchedShow, cancelledWatchedShow, endedWatchedShow, inDevelopmentWatchedShow, returningWatchedShow]

    let filter = ShowProgressFilter.returning.filter()

    let filteredShows = shows.filter(filter)

    // Then
    let expectedShows = [completedWatchedShow, nonCompletedWatchedShow, returningWatchedShow]

    XCTAssertEqual(filteredShows, expectedShows)
  }

  func testShowProgressFilter_filterReturningWatched() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()
    let lastWatched = Date()

    let completedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let nonCompletedWatchedShow = WatchedShowEntity(show: mock.show, aired: 10, completed: 8, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let cancelledShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.canceled, firstAired: nil)

    let endedShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.ended, firstAired: nil)

    let inDevelopmentShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.inDevelopment, firstAired: nil)

    let returningShow = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: Status.returning, firstAired: nil)

    let cancelledWatchedShow = WatchedShowEntity(show: cancelledShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let endedWatchedShow = WatchedShowEntity(show: endedShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let inDevelopmentWatchedShow = WatchedShowEntity(show: inDevelopmentShow, aired: 10, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    let returningWatchedShow = WatchedShowEntity(show: returningShow, aired: 11, completed: 10, nextEpisode: nil, lastWatched: lastWatched, seasons: seasons)

    // When
    let shows = [completedWatchedShow, nonCompletedWatchedShow, cancelledWatchedShow, endedWatchedShow, inDevelopmentWatchedShow, returningWatchedShow]

    let filter = ShowProgressFilter.returningWatched.filter()

    let filteredShows = shows.filter(filter)

    // Then
    let expectedShows = [completedWatchedShow, nonCompletedWatchedShow, returningWatchedShow]

    XCTAssertEqual(filteredShows, expectedShows)
  }
}
