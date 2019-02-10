@testable import CouchTrackerCore
import Nimble
import RxTest
import TraktSwift
import XCTest

final class DefaultWatchedShowSynchronizerSyncStateTests: XCTestCase {
  func testDefaultWatchedShowSynchronizerSyncState_notifySyncingState() {
    // Given
    let downloader = SynchronizerMocks.WatchedShowEntityDownloaderMock()
    let dataSource = SynchronizerMocks.ShowDataSourceMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowSynchronizer(downloader: downloader,
                                                      dataSource: dataSource,
                                                      scheduler: schedulers)

    // When
    let options = WatchedShowEntitySyncOptions(showIds: ShowIds.mock,
                                               episodeExtended: .full,
                                               seasonOptions: .none,
                                               hiddingSpecials: true)
    _ = schedulers.start {
      synchronizer.syncWatchedShow(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
    XCTFail()
  }

  func testDefaultWatchedShowsSynchronizerSync_whenSyncStarts_notifyIsSyncing() {
    // Given
    let downloader = SynchronizerMocks.WatchedShowEntityDownloaderMock()
    let dataSource = SynchronizerMocks.ShowDataSourceMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowSynchronizer(downloader: downloader,
                                                      dataSource: dataSource,
                                                      scheduler: schedulers)

    // When
    let options = WatchedShowEntitySyncOptions(showIds: ShowIds.mock,
                                               episodeExtended: .full,
                                               seasonOptions: .none,
                                               hiddingSpecials: true)

    _ = schedulers.start {
      synchronizer.syncWatchedShow(using: options).asObservable()
    }

    _ = schedulers.start {
      synchronizer.syncWatchedShow(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing),
                          SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
    XCTFail()
//    expect(syncStateOutput.statesNotified).toEventually(equal(expectedStates))
  }

  func testDefaultWatchedShowsSynchronizerSync_whenErrorOccurs_notifyNotSyncing() {
    // Given
    let error = NSError(code: .selfIsDead)
    let downloader = SynchronizerMocks.WatchedShowEntityDownloaderMock(error: error)
    let dataSource = SynchronizerMocks.ShowDataSourceMock()
    let schedulers = TestSchedulers()

    let synchronizer = DefaultWatchedShowSynchronizer(downloader: downloader,
                                                      dataSource: dataSource,
                                                      scheduler: schedulers)

    // When
    let options = WatchedShowEntitySyncOptions(showIds: ShowIds.mock,
                                               episodeExtended: .full,
                                               seasonOptions: .none,
                                               hiddingSpecials: true)
    _ = schedulers.start {
      synchronizer.syncWatchedShow(using: options).asObservable()
    }

    // Then
    let expectedStates = [SyncState(watchedShowsSyncState: .syncing), SyncState(watchedShowsSyncState: .notSyncing)]
    XCTFail()
  }
}
