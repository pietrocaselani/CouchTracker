import XCTest

final class ShowProgressSortTest: XCTestCase {
  func testShowProgressSort_returnAllValues() {
    XCTAssertEqual(ShowProgressSort.allValues(), [ShowProgressSort.title, ShowProgressSort.remaining, ShowProgressSort.lastWatched, ShowProgressSort.releaseDate])
  }

  func testShowProgressSort_returnsSortForIndex() {
    XCTAssertEqual(ShowProgressSort.sort(for: 0), ShowProgressSort.title)
    XCTAssertEqual(ShowProgressSort.sort(for: 1), ShowProgressSort.remaining)
    XCTAssertEqual(ShowProgressSort.sort(for: 2), ShowProgressSort.lastWatched)
    XCTAssertEqual(ShowProgressSort.sort(for: 3), ShowProgressSort.releaseDate)
    XCTAssertEqual(ShowProgressSort.sort(for: -1), ShowProgressSort.title)
    XCTAssertEqual(ShowProgressSort.sort(for: 4), ShowProgressSort.title)
  }

  func testShowProgressSort_returnsIndexForSort() {
    XCTAssertEqual(ShowProgressSort.title.index(), 0)
    XCTAssertEqual(ShowProgressSort.remaining.index(), 1)
    XCTAssertEqual(ShowProgressSort.lastWatched.index(), 2)
    XCTAssertEqual(ShowProgressSort.releaseDate.index(), 3)
  }

  func testShowProgressSort_titleComparator() {
    //Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()

    let showA = ShowEntity(ids: ids, title: "A", overview: nil, network: nil, genres: nil, status: nil, firstAired: nil)
    let showB = ShowEntity(ids: ids, title: "b", overview: nil, network: nil, genres: nil, status: nil, firstAired: nil)
    let showNil = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: nil, status: nil, firstAired: nil)

    let watchedShowA = WatchedShowEntity(show: showA, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShowB = WatchedShowEntity(show: showB, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShowNil = WatchedShowEntity(show: showNil, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let shows = [watchedShowB, watchedShowNil, watchedShowA]

    //When
    let comparator = ShowProgressSort.title.comparator()
    let sortedShows = shows.sorted(by: comparator)

    //Then
    let expectedShows = [watchedShowNil, watchedShowA, watchedShowB]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_remainingComparator() {
    //Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let show = mock.show
    let seasons = [WatchedSeasonEntity]()

    let watchedShow1 = WatchedShowEntity(show: show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShow2 = WatchedShowEntity(show: show, aired: 10, completed: 5, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShow3 = WatchedShowEntity(show: show, aired: 3, completed: 1, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let shows = [watchedShow2, watchedShow1, watchedShow3]

    //When
    let comparator = ShowProgressSort.remaining.comparator()
    let sortedShows = shows.sorted(by: comparator)

    //Then
    let expectedShows = [watchedShow1, watchedShow3, watchedShow2]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_lastWatchedComparator() {
    //Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let show = mock.show
    let seasons = [WatchedSeasonEntity]()

    let date1 = Date(timeIntervalSince1970: 1)
    let date2 = Date(timeIntervalSince1970: 10)
    let date3: Date? = nil

    let watchedShow1 = WatchedShowEntity(show: show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: date1, seasons: seasons)

    let watchedShow2 = WatchedShowEntity(show: show, aired: 10, completed: 5, nextEpisode: nil, lastWatched: date2, seasons: seasons)

    let watchedShow3 = WatchedShowEntity(show: show, aired: 3, completed: 1, nextEpisode: nil, lastWatched: date3, seasons: seasons)

    let watchedShow4 = WatchedShowEntity(show: show, aired: 3, completed: 3, nextEpisode: nil, lastWatched: date3, seasons: seasons)

    let shows = [watchedShow2, watchedShow4, watchedShow1, watchedShow3]

    //When
    let comparator = ShowProgressSort.lastWatched.comparator()
    let sortedShows = shows.sorted(by: comparator)

    //Then
    let expectedShows = [watchedShow2, watchedShow1, watchedShow4, watchedShow3]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_nextEpisodeDataComparator() {
    //Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeMock = ShowsProgressMocks.mockEpisodeEntity()
    let show = mock.show
    let showIds = show.ids
    let episodeIds = episodeMock.ids
    let seasons = [WatchedSeasonEntity]()

    let date1 = Date(timeIntervalSince1970: 1)
    let date2 = Date(timeIntervalSince1970: 10)
    let date3: Date? = nil

    let episode1 = EpisodeEntity(ids: episodeIds, showIds: showIds, title: "", overview: nil, number: 0, season: 0, firstAired: date1, lastWatched: nil)

    let episode2 = EpisodeEntity(ids: episodeIds, showIds: showIds, title: "", overview: nil, number: 0, season: 0, firstAired: date2, lastWatched: nil)

    let episode3 = EpisodeEntity(ids: episodeIds, showIds: showIds, title: "", overview: nil, number: 0, season: 0, firstAired: date3, lastWatched: nil)

    let episode4 = EpisodeEntity(ids: episodeIds, showIds: showIds, title: "", overview: nil, number: 0, season: 0, firstAired: date3, lastWatched: nil)

    let watchedShow1 = WatchedShowEntity(show: show, aired: 10, completed: 10, nextEpisode: episode1, lastWatched: date1, seasons: seasons)

    let watchedShow2 = WatchedShowEntity(show: show, aired: 10, completed: 5, nextEpisode: episode2, lastWatched: date2, seasons: seasons)

    let watchedShow3 = WatchedShowEntity(show: show, aired: 3, completed: 1, nextEpisode: episode3, lastWatched: date3, seasons: seasons)

    let watchedShow4 = WatchedShowEntity(show: show, aired: 3, completed: 3, nextEpisode: episode4, lastWatched: date3, seasons: seasons)

    let shows = [watchedShow2, watchedShow4, watchedShow1, watchedShow3]

    //When
    let comparator = ShowProgressSort.releaseDate.comparator()
    let sortedShows = shows.sorted(by: comparator)

    //Then
    let expectedShows = [watchedShow2, watchedShow1, watchedShow4, watchedShow3]

    XCTAssertEqual(sortedShows, expectedShows)
  }
}
