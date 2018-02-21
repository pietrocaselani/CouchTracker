import RxSwift
import TraktSwift

public protocol ShowProgressRepository: class {
	func fetchShowProgress(ids: ShowIds, hideSpecials: Bool) -> Single<WatchedShowBuilder>
}
