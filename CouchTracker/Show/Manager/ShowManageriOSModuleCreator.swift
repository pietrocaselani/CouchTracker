import CouchTrackerCore

final class ShowManageriOSModuleCreator: ShowManagerModuleCreator {
  private let show: WatchedShowEntity

  init(show: WatchedShowEntity) {
    self.show = show
  }

  func createModule(for option: ShowManagerOption) -> BaseView {
    switch option {
    case .overview:
      return ShowOverviewModule.setupModule(showIds: show.show.ids)
    case .episode:
      return ShowEpisodeModule.setupModule(for: show)
    case .seasons:
      return ShowSeasonsModule.setupModule(for: show)
    }
  }
}
