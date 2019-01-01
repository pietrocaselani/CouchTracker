@testable import CouchTrackerCore
import RxSwift
import TraktSwift

final class ShowEpisodeMocks {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  final class Interactor: ShowEpisodeInteractor {
    var fetchImageURLInvoked = false
    var fetchImageURLParameters: EpisodeImageInput?
    var toogleWatchInvoked = false
    var toogleWatchParameters: WatchedEpisodeEntity?
    var error: Error?
    var toogleFailError: Error?
    var nextEntity: WatchedShowEntity!
    var shouldEmitImages = true

    init() {
      nextEntity = ShowsProgressMocks.mockWatchedShowEntity()
    }

    func fetchImages(for episode: EpisodeImageInput) -> Maybe<ShowEpisodeImages> {
      fetchImageURLInvoked = true
      fetchImageURLParameters = episode

      if let fetchError = error {
        return Maybe.error(fetchError)
      }

      guard shouldEmitImages else { return Maybe.empty() }

      let url = URL(fileURLWithPath: "path/to/image.png")
      return Maybe.just(ShowEpisodeImages(posterURL: url, previewURL: url))
    }

    func toggleWatch(for episode: WatchedEpisodeEntity) -> Single<WatchedShowEntity> {
      toogleWatchInvoked = true
      toogleWatchParameters = episode

      if let toogleError = error {
        return Single.error(toogleError)
      }

      if let toogleError = toogleFailError {
        return Single.error(toogleError)
      }

      return Single.just(nextEntity)
    }
  }

  final class ShowEpisodeRepositoryMock: ShowEpisodeRepository {
    var addToHistoryInvoked = false
    var addToHistoryParameters: EpisodeEntity?
    var removeFromHistoryInvoked = false
    var removeFromHistoryParameters: EpisodeEntity?

    func addToHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity> {
      addToHistoryInvoked = true
      addToHistoryParameters = episode
      return Single.never()
    }

    func removeFromHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity> {
      removeFromHistoryInvoked = true
      removeFromHistoryParameters = episode
      return Single.never()
    }
  }

  final class ShowEpisodeNetworkMock: ShowEpisodeNetwork {
    var addToHistoryInvoked = false
    var removeFromHistoryInvoked = false

    func addToHistory(items _: SyncItems) -> Single<SyncResponse> {
      addToHistoryInvoked = true
      return Single.deferred { () -> Single<SyncResponse> in
        let syncResponse: SyncResponse = TraktEntitiesMock.decodeTraktJSON(with: "trakt_sync_addtohistory")
        return Single.just(syncResponse)
      }
    }

    func removeFromHistory(items _: SyncItems) -> Single<SyncResponse> {
      removeFromHistoryInvoked = true
      return Single.deferred { () -> Single<SyncResponse> in
        let syncResponse: SyncResponse = TraktEntitiesMock.decodeTraktJSON(with: "trakt_sync_removefromhistory")
        return Single.just(syncResponse)
      }
    }
  }

  final class ShowEpisodeNetworkErrorMock: ShowEpisodeNetwork {
    var addToHistoryInvoked = false
    var removeFromHistoryInvoked = false
    let error: Error

    init(error: Error) {
      self.error = error
    }

    func addToHistory(items _: SyncItems) -> Single<SyncResponse> {
      addToHistoryInvoked = true
      return Single.error(error)
    }

    func removeFromHistory(items _: SyncItems) -> Single<SyncResponse> {
      removeFromHistoryInvoked = true
      return Single.error(error)
    }
  }
}
