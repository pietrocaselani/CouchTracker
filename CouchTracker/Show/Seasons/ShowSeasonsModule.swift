import CouchTrackerCore
import RxSwift
import UIKit

final class ShowSeasonsModule {
  private init() {}

  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    return ShowSeasonsViewController(show: show)
  }
}
