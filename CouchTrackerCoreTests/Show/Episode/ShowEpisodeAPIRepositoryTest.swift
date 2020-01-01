@testable import CouchTrackerCore
import Nimble
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class ShowEpisodeAPIRepositoryTest: XCTestCase {
  func testShowEpisodeAPIRepository_addToHistoryWithNetworkError_emitsSyncResultFail() {
    // Given
    let network = ShowEpisodeMocks.ShowEpisodeNetworkErrorMock(error: TraktError.mock())
    let schedulers = TestSchedulers()
    let appStateObservableMock = AppStateMock.AppStateObservableMock()

    let synchronizer = SynchronizerMocks.WatchedShowSynchronizerMock()

    let repository = ShowEpisodeAPIRepository(network: network,
                                              schedulers: schedulers,
                                              synchronizer: synchronizer,
                                              appConfigurationsObservable: appStateObservableMock,
                                              hideSpecials: true)

    // When
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.addToHistory(episode: episodeEntity).asObservable()
    }

    // Then
    let expectedEvents = [Recorded.error(200, TraktError.mock(), WatchedShowEntity.self)]

    XCTAssertEqual(res.events, expectedEvents)

    expect(synchronizer.syncWatchedShowInvokedCount).to(be(0))
    expect(network.addToHistoryInvoked).to(beTrue())
    expect(network.removeFromHistoryInvoked).to(beFalse())
  }

  func testShowEpisodeAPIRepository_removeFromHistoryWithNetworkError_emitsSyncResultFail() {
    // Given
    let network = ShowEpisodeMocks.ShowEpisodeNetworkErrorMock(error: TraktError.mock())
    let schedulers = TestSchedulers()
    let appStateObservableMock = AppStateMock.AppStateObservableMock()

    let synchronizer = SynchronizerMocks.WatchedShowSynchronizerMock()

    let repository = ShowEpisodeAPIRepository(network: network,
                                              schedulers: schedulers,
                                              synchronizer: synchronizer,
                                              appConfigurationsObservable: appStateObservableMock,
                                              hideSpecials: true)

    // When
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.removeFromHistory(episode: episodeEntity).asObservable()
    }

    // Then
    let expectedEvents = [Recorded.error(200, TraktError.mock(), WatchedShowEntity.self)]
    XCTAssertEqual(res.events, expectedEvents)

    expect(synchronizer.syncWatchedShowInvokedCount).to(be(0))
    expect(network.addToHistoryInvoked).to(beFalse())
    expect(network.removeFromHistoryInvoked).to(beTrue())
  }

  func testShowEpisodeAPIRepository_tryToChangeHistoryChangingAppStateHideSpecials_expectAppStateHideSpecialFalse() {
    // Given
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appStateObservableMock = AppStateMock.AppStateObservableMock()

    let synchronizer = SynchronizerMocks.WatchedShowSynchronizerMock(error: TraktError.mock())

    let repository = ShowEpisodeAPIRepository(network: network,
                                              schedulers: schedulers,
                                              synchronizer: synchronizer,
                                              appConfigurationsObservable: appStateObservableMock,
                                              hideSpecials: true)

    appStateObservableMock.change(state: AppState(userSettings: nil, hideSpecials: false))

    // When
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    _ = schedulers.start {
      repository.removeFromHistory(episode: episodeEntity).asObservable()
    }

    // Then
    XCTAssertFalse(synchronizer.lastOptionsParameter?.hidingSpecials ?? true)
  }

  func testShowEpisodeAPIRepository_addToHistorSuccess_emitsSyncResultWithShow() {
    // Given
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appStateObservableMock = AppStateMock.AppStateObservableMock()

    let synchronizer = SynchronizerMocks.WatchedShowSynchronizerMock()

    let repository = ShowEpisodeAPIRepository(network: network,
                                              schedulers: schedulers,
                                              synchronizer: synchronizer,
                                              appConfigurationsObservable: appStateObservableMock,
                                              hideSpecials: true)

    // When
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.addToHistory(episode: episodeEntity).asObservable()
    }

    // Then
    let expectedElement = WatchedShowEntity.mockEndedAndCompleted()
    let expectedEvents = [Recorded.next(200, expectedElement), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testShowEpisodeAPIRepository_removeFromHistorSuccess_emitsSyncResultWithShow() {
    // Given
    let network = ShowEpisodeMocks.ShowEpisodeNetworkMock()
    let schedulers = TestSchedulers()
    let appStateObservableMock = AppStateMock.AppStateObservableMock()

    let synchronizer = SynchronizerMocks.WatchedShowSynchronizerMock()

    let repository = ShowEpisodeAPIRepository(network: network,
                                              schedulers: schedulers,
                                              synchronizer: synchronizer,
                                              appConfigurationsObservable: appStateObservableMock,
                                              hideSpecials: true)

    // When
    let episodeEntity = ShowsProgressMocks.mockEpisodeEntity()

    let res = schedulers.start {
      repository.removeFromHistory(episode: episodeEntity).asObservable()
    }

    // Then
    let expectedElement = WatchedShowEntity.mockEndedAndCompleted()
    let expectedEvents = [Recorded.next(200, expectedElement), Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }
}
