import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class ShowEpisodeMocks {
	private init() {
		Swift.fatalError("No instances for you!")
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

		func addToHistory(items: SyncItems) -> Single<SyncResponse> {
			addToHistoryInvoked = true
			return Single.deferred { () -> Single<SyncResponse> in
				let syncResponse: SyncResponse = TraktEntitiesMock.decodeTraktJSON(with: "trakt_sync_addtohistory")
				return Single.just(syncResponse)
			}
		}

		func removeFromHistory(items: SyncItems) -> Single<SyncResponse> {
			removeFromHistoryInvoked = true
			return Single.deferred { () -> Single<SyncResponse> in
				let syncResponse: SyncResponse = TraktEntitiesMock.decodeTraktJSON(with: "trakt_sync_addtohistory")
				return Single.just(syncResponse)
			}
		}
	}
}
