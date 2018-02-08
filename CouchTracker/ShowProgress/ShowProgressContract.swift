import RxSwift
import TraktSwift

protocol ShowProgressRepository: class {
  func fetchShowProgress(ids: ShowIds) -> Single<WatchedShowBuilder>
}
