import CouchTrackerCore

enum ShowManagerModule {
  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    let userDefaults = Environment.instance.userDefaults

    let creator = ShowManageriOSModuleCreator(show: show)
    let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)
    let presenter = ShowManagerDefaultPresenter(dataSource: dataSource)

    return ShowManagerViewController(presenter: presenter)
  }
}
