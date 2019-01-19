import CouchTrackerCore
import RxSwift

enum SynchronizerMocks {
  final class WatchedShowSynchronizerMock: WatchedShowSynchronizer {
    let error: Error?
    var syncWatchedShowInvokedCount = 0
    var lastOptionsParameter: WatchedShowEntitySyncOptions?

    init(error: Error? = nil) {
      self.error = error
    }

    func syncWatchedShow(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowEntity> {
      lastOptionsParameter = options
      guard let error = error else {
        return Single.just(WatchedShowEntity.mockEndedAndCompleted())
      }

      return Single.error(error)
    }
  }

  final class WatchedShowEntitiesDownloaderMock: WatchedShowEntitiesDownloader {
    func syncWatchedShowEntities(using _: WatchedShowEntitiesSyncOptions) -> Observable<WatchedShowEntity> {
      return Observable.empty()
    }
  }

  final class ShowsDataHolderMock: ShowsDataHolder {
    var saveShowsLastestParemeter: [WatchedShowEntity]?
    var saveShowInvokedCount = 0

    func save(shows: [WatchedShowEntity]) throws {
      saveShowsLastestParemeter = shows
      saveShowInvokedCount += 1
    }
  }
}
