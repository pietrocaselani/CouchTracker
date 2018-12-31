import CouchTrackerCore
import RxSwift

final class ShowSeasonsModule {
  private init() {}

  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    let observable = Environment.instance.watchedShowEntityObserable.observeWatchedShow(showIds: show.show.ids)

    return ShowSeasonsViewController(show: observable)
  }
}
