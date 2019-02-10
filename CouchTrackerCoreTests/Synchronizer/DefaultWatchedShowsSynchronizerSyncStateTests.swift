@testable import CouchTrackerCore
import RxTest
import TraktSwift
import XCTest

final class DefaultWatchedShowsSynchronizerSyncStateTests: XCTestCase {
  func testDefaultWatchedShowsSynchronizerSync_notifySyncingState() {
    // Given
    let downloader = SynchronizerMocks.WatchedShowEntitiesDownloaderMock()
    let dataHolder = SynchronizerMocks.ShowsDataHolderMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowsSynchronizer(downloader: downloader,
                                                       dataHolder: dataHolder,
                                                       schedulers: schedulers)

    // When
    let options = WatchedShowEntitiesSyncOptions(extended: Extended.defaultMin, hiddingSpecials: false)
    _ = schedulers.start {
      synchronizer.syncWatchedShows(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
//    XCTAssertEqual(expectedStates, syncStateOutput.statesNotified)
    XCTFail()
  }

  func testDefaultWatchedShowsSynchronizerSync_whenSyncStarts_notifyIsSyncing() {
    // Given
    let downloader = SynchronizerMocks.WatchedShowEntitiesDownloaderMock()
    let dataHolder = SynchronizerMocks.ShowsDataHolderMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowsSynchronizer(downloader: downloader,
                                                       dataHolder: dataHolder,
                                                       schedulers: schedulers)

    // When
    let options = WatchedShowEntitiesSyncOptions(extended: Extended.defaultMin, hiddingSpecials: false)
    _ = schedulers.start {
      synchronizer.syncWatchedShows(using: options).asObservable()
    }

    _ = schedulers.start {
      synchronizer.syncWatchedShows(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing),
                          SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
    XCTFail()
  }

  func testDefaultWatchedShowsSynchronizerSync_whenErrorOccurs_notifyNotSyncing() {
    // Given
    let error = NSError(code: .selfIsDead)
    let downloader = SynchronizerMocks.WatchedShowEntitiesDownloaderMock(error: error)
    let dataHolder = SynchronizerMocks.ShowsDataHolderMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowsSynchronizer(downloader: downloader,
                                                       dataHolder: dataHolder,
                                                       schedulers: schedulers)

    // When
    let options = WatchedShowEntitiesSyncOptions(extended: Extended.defaultMin, hiddingSpecials: false)
    _ = schedulers.start {
      synchronizer.syncWatchedShows(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
    XCTFail()
  }
}
