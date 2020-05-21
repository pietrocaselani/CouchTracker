import Moya
import RxSwift
import RxTest
import TraktSwift
import XCTest
import RxMoya

final class SeasonsTests: XCTestCase {
  private let seasonsProvider = MoyaProvider<Seasons>(stubClosure: MoyaProvider.immediatelyStub)
  private var scheduler: TestScheduler!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()

    scheduler = nil
  }

  func testSeasons_requestSummaryforSeason_parseModels() {
    let target = Seasons.summary(showId: "the-100", extended: [.full, .episodes])

    let res = scheduler.start {
      self.seasonsProvider.rx.request(target)
        .map([Season].self)
        .asObservable()
    }

    let expectedSeasons: [Season]

    do {
      expectedSeasons = try JSONDecoder().decode([Season].self, from: target.sampleData)
    } catch {
      Swift.fatalError("Unable to parse JSON: \(error)")
    }

    let expectedEvents = [Recorded.next(200, expectedSeasons), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }
}
