import XCTest
import Moya
import TraktSwift
import TraktSwiftTestable
import RxSwift
import RxTest
import Nimble
import RxNimble

@testable import CouchTrackerSync

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

    func testSync() {
      let expectedWatchedProgressOptions = WatchedProgressOptions(hidden: false, specials: false, countSpecials: false)
      let expectedShowIds = ShowIds(trakt: 1415,
                                    tmdb: 1424,
                                    imdb: "tt2372162",
                                    slug: "orange-is-the-new-black",
                                    tvdb: 264586,
                                    tvrage: 32950)

      Current.syncWatchedShows = { extended in
        XCTAssertEqual(extended, [.full, .noSeasons])
        return .just(decode(file: "syncWatchedShows", as: [BaseShow].self))
      }

      Current.watchedProgress = { watchedProgressOptions, showIds in
        XCTAssertEqual(watchedProgressOptions, expectedWatchedProgressOptions)
        XCTAssertEqual(showIds, expectedShowIds)
        return .just(decode(file: "watchedProgress", as: BaseShow.self))
      }

      Current.seasonsForShow = { showIds, extended in
        XCTAssertEqual(showIds, expectedShowIds)
        XCTAssertEqual(extended, [.full, .episodes])
        return .just(decode(file: "seasonsForShow", as: [Season].self))
      }

      Current.genres = {
        let movies = Observable.just(decode(file: "genresForMovies", as: [Genre].self))
        let shows = Observable.just(decode(file: "genresForShows", as: [Genre].self))
        return Observable.zip(movies, shows).map { Set($0 + $1) }
      }

      expect(startSync(options: SyncOptions()))
        .events(scheduler: scheduler, disposeBag: disposeBag)
        .to(equal([
          Recorded.next(0, decode(file: "WatchedShow-Success", as: WatchedShow.self)),
          Recorded.completed(0)
        ]))
    }
}
