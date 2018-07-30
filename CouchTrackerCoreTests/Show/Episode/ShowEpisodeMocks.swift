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
        var toogleWatchParameters: (episode: EpisodeEntity, show: WatchedShowEntity)?
        var error: Error?
        var toogleFailError: Error?
        var nextEntity: WatchedShowEntity!

        init() {
            nextEntity = ShowsProgressMocks.mockWatchedShowEntity()
        }

        func fetchImageURL(for episode: EpisodeImageInput) -> Maybe<URL> {
            fetchImageURLInvoked = true
            fetchImageURLParameters = episode

            if let fetchError = error {
                return Maybe.error(fetchError)
            }

            let url = URL(fileURLWithPath: "path/to/image.png")
            return Maybe.just(url)
        }

        func toggleWatch(for episode: EpisodeEntity, of show: WatchedShowEntity) -> Single<SyncResult> {
            toogleWatchInvoked = true
            toogleWatchParameters = (episode, show)

            if let toogleError = error {
                return Single.error(toogleError)
            }

            if let toogleError = toogleFailError {
                return Single.just(SyncResult.fail(error: toogleError))
            }

            return Single.just(SyncResult.success(show: nextEntity))
        }
    }

    final class ShowEpisodeRepositoryMock: ShowEpisodeRepository {
        var addToHistoryInvoked = false
        var addToHistoryParameters: (show: WatchedShowEntity, episode: EpisodeEntity)?
        var removeFromHistoryInvoked = false
        var removeFromHistoryParameters: (show: WatchedShowEntity, episode: EpisodeEntity)?

        func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
            addToHistoryInvoked = true
            addToHistoryParameters = (show, episode)
            return Single.never()
        }

        func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
            removeFromHistoryInvoked = true
            removeFromHistoryParameters = (show, episode)
            return Single.never()
        }
    }

    final class ShowEpisodeDataSourceMock: ShowEpisodeDataSource {
        var updateWatchedShowInvoked = false
        var updateWatchedShowParameter: WatchedShowEntity?

        func updateWatched(show: WatchedShowEntity) throws {
            updateWatchedShowInvoked = true
            updateWatchedShowParameter = show
        }
    }

    final class ShowEpisodeDataSourceErrorMock: ShowEpisodeDataSource {
        var updateWatchedShowInvoked = false
        var updateWatchedShowParameter: WatchedShowEntity?
        let error: Error

        init(error: Error) {
            self.error = error
        }

        func updateWatched(show: WatchedShowEntity) throws {
            updateWatchedShowInvoked = true
            updateWatchedShowParameter = show
            throw error
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
}
