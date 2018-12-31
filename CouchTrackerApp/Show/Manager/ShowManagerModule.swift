import CouchTrackerCore

enum ShowManagerModule {
  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    let initialView = R.storyboard.showManager().instantiateInitialViewController()
    guard let showManagerView = initialView as? ShowManagerViewController else {
      fatalError("topViewController should be an instance of ShowsManagerViewController")
    }

    let userDefaults = Environment.instance.userDefaults

    let creator = ShowManageriOSModuleCreator(show: show)
    let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: userDefaults)
    let presenter = ShowManagerDefaultPresenter(dataSource: dataSource)

    showManagerView.presenter = presenter

    return showManagerView
  }
}
