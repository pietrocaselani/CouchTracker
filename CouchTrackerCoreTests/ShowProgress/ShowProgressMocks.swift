import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class ShowProgressMocks {
	static let showProgressRepository = ShowProgressAPIRepositoryMock()

	private init() {}

	final class ShowProgressRepositoryMock: ShowProgressRepository {
		var fetchShowProgressInvoked = false
		var fetchShowProgressParameters: (ids: ShowIds, hideSpecial: Bool)?

		func fetchShowProgress(ids: ShowIds, hideSpecials: Bool) -> Single<WatchedShowBuilder> {
			fetchShowProgressInvoked = true
			fetchShowProgressParameters = (ids, hideSpecials)

			let baseShow = ShowsProgressMocks.createShowMock("pc")!

			let dateTransformer = TraktDateTransformer.dateTimeTransformer

			let episode0 = WatchedEpisodeEntity(showIds: ids, number: 1, lastWatchedAt: dateTransformer.transformFromJSON("2017-09-18T02:11:57.000Z"))
			let episode1 = WatchedEpisodeEntity(showIds: ids, number: 9, lastWatchedAt: nil)

			let season0 = WatchedSeasonEntity(showIds: ids, number: 5, aired: 13, completed: 8, episodes: [episode0, episode1])

			let builder = WatchedShowBuilder(ids: ids, progressShow: baseShow, seasons: [season0])

			return Single.just(builder)
		}
	}

	final class ShowProgressAPIRepositoryMock: ShowProgressRepository {
		private let baseShow: BaseShow?
		private let baseShowError: Error?
		private let episode: Episode?
		private let episodeError: Error?
		private let trakt = createTraktProviderMock()

		init(baseShow: BaseShow? = nil, baseShowError: Error? = nil, episode: Episode? = nil, episodeError: Error? = nil) {
			self.baseShow = baseShow
			self.baseShowError = baseShowError
			self.episode = episode
			self.episodeError = episodeError
		}

		func fetchShowProgress(ids: ShowIds, hideSpecials: Bool) -> Single<WatchedShowBuilder> {
			if let error = baseShowError { return Single.error(error) }

			if let error = episodeError { return Single.error(error) }

			let target = Shows.watchedProgress(showId: ids.realId, hidden: !hideSpecials, specials: !hideSpecials, countSpecials: !hideSpecials)
			let single = trakt.shows.rx.request(target).map(BaseShow.self)

			return single.flatMap { baseShowMock -> Single<WatchedShowBuilder> in
				let builder = WatchedShowBuilder(ids: ids)
				builder.progressShow = baseShowMock
				return self.fetchEpisodeDetails(ids, builder, baseShowMock.nextEpisode)
			}
		}

		private func fetchEpisodeDetails(_ ids: ShowIds, _ builder: WatchedShowBuilder, _ episode: Episode?) -> Single<WatchedShowBuilder> {
			guard let nextEpisode = episode else { return Single.just(builder) }

			let episodeTarget = Episodes.summary(showId: ids.realId, season: nextEpisode.season,
																					episode: nextEpisode.number, extended: Extended.fullEpisodes)

			let single = self.trakt.episodes.rx.request(episodeTarget).map(Episode.self)
			return single.map { e -> WatchedShowBuilder in
				builder.episode = e
				return builder
			}
		}
	}
}
