import CouchTrackerCore
import UIKit

final class ShowSeasonsModule {
  private init() {}

  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    show.seasons.forEach {
      print("Season \($0.number) completed: \($0.completed ?? 0)/\($0.aired ?? 0)")
    }
    return UIViewController()
  }
}
