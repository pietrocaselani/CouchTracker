import RxSwift

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
}
