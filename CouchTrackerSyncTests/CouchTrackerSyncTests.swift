import XCTest
import TraktSwift
import RxSwift
import RxTest
import SnapshotTesting
import CouchTrackerSync
import TraktSwiftTestable

final class CouchTrackerSyncTests: XCTestCase {
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var genresInvokedCount = 0

  override func setUp() {
    super.setUp()

    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)

    Current.api.genres = {
      self.genresInvokedCount += 1
      let movies = Single.just(decode(file: "genresForMovies", as: [Genre].self))
      let shows = Single.just(decode(file: "genresForShows", as: [Genre].self))
      return Single.zip(movies, shows).map { Set($0 + $1) }
    }
  }

  override func tearDown() {
    scheduler = nil
    disposeBag = nil
    genresInvokedCount = 0
    super.tearDown()
  }

  func testSyncForOneShowOnly() {
    let expectedWatchedProgressOptions = WatchedProgressOptions()

    let expectedShowIds = ShowIds(trakt: 1415,
                                  tmdb: 1424,
                                  imdb: "tt2372162",
                                  slug: "orange-is-the-new-black",
                                  tvdb: 264586,
                                  tvrage: 32950)

    Current.api.syncWatchedShows = { extended in
      XCTAssertEqual(extended, [.full, .noSeasons])
      return .just(decode(file: "syncWatchedShows", as: [BaseShow].self))
    }

    Current.api.watchedProgress = { watchedProgressOptions, showIds in
      XCTAssertEqual(watchedProgressOptions, expectedWatchedProgressOptions)
      XCTAssertEqual(showIds, expectedShowIds)
      return .just(decode(file: "watchedProgress", as: BaseShow.self))
    }

    Current.api.seasonsForShow = { showIds, extended in
      XCTAssertEqual(showIds, expectedShowIds)
      XCTAssertEqual(extended, [.full, .episodes])
      return .just(decode(file: "seasonsForShow", as: [TraktSwift.Season].self))
    }

    let trakt = TestableTrakt()
    let startModule = setupSyncModule(trakt: trakt, scheduler: scheduler)

    let observer = scheduler.start { () -> Observable<CouchTrackerSync.Show> in
      startModule(.defaultOptions)
    }

    assertSnapshot(matching: observer.events, as: .unsortedJSON)
  }

  func testSyncWatchedShows() {
    var syncWatchedShowsInvokedCount = 0
    var watchedProgressInvokedCount = 0
    var seasonsForShowInvokedCount = 0

    Current.api.syncWatchedShows = { extended in
      syncWatchedShowsInvokedCount += 1
      return .just(decode(file: "syncWatchedShows-full", as: [BaseShow].self))
    }

    Current.api.watchedProgress = { watchedProgressOptions, showIds in
      watchedProgressInvokedCount += 1
      return .just(decode(file: "watchedProgress-\(showIds.trakt)", as: BaseShow.self))
    }

    Current.api.seasonsForShow = { showIds, extended in
      seasonsForShowInvokedCount += 1
      return .just(decode(file: "seasons-\(showIds.trakt)", as: [TraktSwift.Season].self))
    }

    let trakt = TestableTrakt()
    let startModule = setupSyncModule(trakt: trakt, scheduler: scheduler)

    let observer = scheduler.start { () -> Observable<CouchTrackerSync.Show> in
      startModule(.defaultOptions)
    }

    XCTAssertEqual(syncWatchedShowsInvokedCount, 1)
    XCTAssertEqual(genresInvokedCount, 1)
    XCTAssertEqual(watchedProgressInvokedCount, 3)
    XCTAssertEqual(seasonsForShowInvokedCount, 3)

    assertSnapshot(matching: observer.events, as: .json)
  }
}
