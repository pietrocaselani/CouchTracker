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
}
