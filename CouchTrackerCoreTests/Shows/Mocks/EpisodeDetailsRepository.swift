import CouchTrackerCore
import TraktSwift
import RxSwift

final class EpisodeDetailsRepositoryMock: EpisodeDetailsRepository {
	func fetchDetailsOf(episode: Int, season: Int, from showId: ShowIds, extended: Extended) -> Single<Episode> {
		let episode: Episode = TraktEntitiesMock.decodeTraktJSON(with: "trakt_episodes_summary")
		return Single.just(episode)
	}
}
