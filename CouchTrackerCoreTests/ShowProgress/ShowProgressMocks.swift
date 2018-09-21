@testable import CouchTrackerCore
import RxSwift
import TraktSwift

final class ShowProgressMocks {
  private init() {}

  final class ShowWatchedProgressRepositoryMock: ShowWatchedProgressRepository {
    var fetchShowWatchedProgressInvoked = false
    var fetchShowWatchedProgressInvokedParameters: (showId: ShowIds, hideSpecials: Bool)?

    private let jsonFile: String

    init(nextEpisode: Bool = false) {
      jsonFile = nextEpisode ? "trakt_shows_watchedprogress" : "trakt_shows_watchedprogress_without_nextepisode"
    }

    func fetchShowWatchedProgress(showId: ShowIds, hideSpecials: Bool) -> Single<BaseShow> {
      fetchShowWatchedProgressInvoked = true
      fetchShowWatchedProgressInvokedParameters = (showId, hideSpecials)

      let show: BaseShow = TraktEntitiesMock.decodeTraktJSON(with: jsonFile)
      return Single.just(show)
    }
  }
}
