import XCTest
@testable import CouchTrackerSync
import Moya

import TraktSwift
import TraktSwiftTestable

import RxSwift
import RxTest

import Nimble
import RxNimble

private final class TestableClass: NSObject {}

private let bundle = Bundle(for: TestableClass.self)

final class SyncWatchedShowsTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "SyncWatchedShowsTestsUserDefaults")!
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

    let expectedShows = try JSONDecoder().decode([BaseShow].self, from: data)

    Current.trakt = makeTrakt(responseStubbed)

    expect(syncWatchedShows())
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        Recorded.next(0, expectedShows),
        Recorded.completed(0)
      ]))
  }

  private func contentsOf(file named: String) -> Data {
    return bundle.url(forResource: named, withExtension: "json").map { try! Data(contentsOf: $0) }!
  }

  private func makeTrakt(_ sampleResponse: EndpointSampleResponse) -> SyncTestableTrakt<Sync> {
    let builder = TraktBuilder {
      $0.clientId = "clientIdMock"
      $0.clientSecret = "clientSecretMock"
      $0.redirectURL = "https://google.com"
      $0.userDefaults = userDefaultsMock
    }

    return SyncTestableTrakt(builder: builder, endpointClosure: { target in
      return Endpoint(
          url: URL(target: target).absoluteString,
          sampleResponseClosure: { sampleResponse },
          method: target.method,
          task: target.task,
          httpHeaderFields: target.headers
      )
    })
  }
}
