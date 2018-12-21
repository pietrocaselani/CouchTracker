import CouchTrackerCore
import RxSwift

enum SynchronizerMocks {
  final class WatchedShowSynchronizerMock: WatchedShowSynchronizer {
    func syncWatchedShow(using _: WatchedShowEntitySyncOptions) -> PrimitiveSequence<SingleTrait, WatchedShowEntity> {
      return Single.just(ShowsProgressMocks.mockWatchedShowEntity())
    }
  }
}
