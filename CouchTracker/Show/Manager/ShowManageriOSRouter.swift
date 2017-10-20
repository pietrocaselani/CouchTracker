import UIKit

final class ShowManageriOSRouter: ShowManagerRouter {
  private weak var viewController: UIViewController?
  private let entity: WatchedShowEntity

  init(viewController: UIViewController, entity: WatchedShowEntity) {
    self.viewController = viewController
    self.entity = entity
  }

  func show(option: ShowManagerOption) {
    guard let navigationController = viewController?.navigationController else { return }

    guard let view = moduleView(for: option) as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    navigationController.pushViewController(view, animated: true)
  }

  private func moduleView(for option: ShowManagerOption) -> BaseView {
    if option == .overview { return ShowOverviewModule.setupModule() }
    if option == .episode { return ShowEpisodeModule.setupModule(for: entity) }
    return ShowSeasonsModule.setupModule()
  }
}
