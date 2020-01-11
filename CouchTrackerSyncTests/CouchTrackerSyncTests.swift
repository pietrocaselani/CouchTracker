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

  override func setUp() {
    super.setUp()

    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    scheduler = nil
    disposeBag = nil
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
      return .just(decode(file: "seasonsForShow", as: [Season].self))
    }

    Current.api.genres = {
      let movies = Single.just(decode(file: "genresForMovies", as: [Genre].self))
      let shows = Single.just(decode(file: "genresForShows", as: [Genre].self))
      return Single.zip(movies, shows).map { Set($0 + $1) }
    }

    let trakt = TestableTrakt()

    let observer = scheduler.start { () -> Observable<WatchedShow> in
      let startModule = setupSyncModule(trakt: trakt)
      return startModule(.defaultOptions)
    }

    assertSnapshot(matching: observer.events, as: .unsortedJSON)
  }
}
