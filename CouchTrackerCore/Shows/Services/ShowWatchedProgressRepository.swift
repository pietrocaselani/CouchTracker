import RxSwift
import TraktSwift

public protocol ShowWatchedProgressRepository {
  func fetchShowWatchedProgress(showId: ShowIds, hideSpecials: Bool) -> Single<BaseShow>
}
