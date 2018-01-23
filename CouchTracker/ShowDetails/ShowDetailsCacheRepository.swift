import RxSwift
import Moya
import TraktSwift

final class ShowDetailsCacheRepository: ShowDetailsRepository {
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return traktProvider.shows.rx.request(.summary(showId: identifier, extended: extended)).map(Show.self)
  }
}
