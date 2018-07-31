@testable import CouchTrackerCore
import RxSwift
import TraktSwift
import XCTest

final class ShowEpisodeMoyaNetworkTest: XCTestCase {
  private let schedulers = TestSchedulers()
  private let trakt = createTraktProviderMock()

  func testShowEpisodeMoyaNetwork_addToHistory() {
    // Given
    let network = ShowEpisodeMoyaNetwork(trakt: trakt, schedulers: schedulers)
    let episodes = [SyncEpisode(ids: ShowsProgressMocks.mockEpisodeEntity().ids)]
    let items = SyncItems(episodes: episodes)

    // When
    let res = schedulers.testScheduler.start {
      network.addToHistory(items: items).asObservable()
    }

    // Then
    guard let providerMock = self.trakt.sync as? MoyaProviderMock else {
      XCTFail()
      return
    }

    XCTAssertTrue(providerMock.requestInvoked)
    XCTAssertEqual(providerMock.requestInvokedCount, 1)
    XCTAssertEqual(res.events.count, 2)
  }

  func testShowEpisodeMoyaNetwork_removeFromHistory() {
    // Given
    let network = ShowEpisodeMoyaNetwork(trakt: trakt, schedulers: schedulers)
    let episodes = [SyncEpisode(ids: ShowsProgressMocks.mockEpisodeEntity().ids)]
    let items = SyncItems(episodes: episodes)

    // When
    let res = schedulers.testScheduler.start {
      network.removeFromHistory(items: items).asObservable()
    }

    // Then
    guard let providerMock = self.trakt.sync as? MoyaProviderMock else {
      XCTFail()
      return
    }

    XCTAssertTrue(providerMock.requestInvoked)
    XCTAssertEqual(providerMock.requestInvokedCount, 1)
    XCTAssertEqual(res.events.count, 2)
  }
}
