import CouchTrackerCore
import TraktSwift
import RxSwift

final class ShowSeasonsRepositoryMock: ShowSeasonsRepository {
	func fetchShowSeasons(showIds: ShowIds, extended: Extended) -> Single<[Season]> {
		return Single.just([Season]())
	}
}
