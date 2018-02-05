import RxSwift
import TraktSwift

protocol ShowProgressRepository: class {
  func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow>
  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode>
}

protocol ShowProgressInteractor: class {
  func fetchShowProgress(ids: ShowIds) -> Observable<WatchedShowBuilder>
}
