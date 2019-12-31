import XCTest
import Moya
import TraktSwift
import TraktSwiftTestable
import RxSwift
import RxTest
import Nimble
import RxNimble

@testable import CouchTrackerSync

final class SyncWatchedShowsTests: XCTestCase {
  private var originalTrakt: TraktProvider!
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    disposeBag = DisposeBag()
    originalTrakt = Current.trakt
    scheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    Current.trakt = originalTrakt
    scheduler = nil
    disposeBag = nil
    super.tearDown()
  }

  func testSyncWatchedShows() throws {
    let data = contentsOf(file: "SyncWatchedShowsSuccess")
    let responseStubbed = EndpointSampleResponse.networkResponse(200, data)
    let trakt: SyncTestableTrakt<Sync> = makeTestableTrakt(responseStubbed)
    Current.trakt = trakt

    let expectedShows = try JSONDecoder().decode([BaseShow].self, from: data)

    expect(syncWatchedShows())
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        Recorded.next(0, expectedShows),
        Recorded.completed(0)
      ]))
  }
}
