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
    Current.syncWatchedShows = { _ in
      Observable.just(decode(file: "syncWatchedShows-Success", as: [BaseShow].self))
    }

    Current.watchedProgress = { _, _ in
      Observable.just(decode(file: "watchedProgress-Success", as: BaseShow.self))
    }

    let expectedShows = decode(file: "baseShow-Success", as: BaseShow.self)

    let observable = startSync(options: SyncOptions())

    expect(observable)
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        Recorded.next(0, expectedShows),
        Recorded.completed(0)
      ]))
  }
}
