import RxSwift
import TraktSwift

public protocol ShowSeasonsRepository {
  func fetchShowSeasons(showIds: ShowIds, extended: Extended) -> Single<[Season]>
}
