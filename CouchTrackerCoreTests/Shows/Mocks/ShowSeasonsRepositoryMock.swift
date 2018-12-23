import CouchTrackerCore
import RxSwift
import TraktSwift

final class ShowSeasonsRepositoryMock: ShowSeasonsRepository {
  func fetchShowSeasons(showIds _: ShowIds, extended _: Extended) -> Single<[Season]> {
    return Single.just([Season]())
  }
}
