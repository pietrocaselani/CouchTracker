import CouchTrackerCore
import UIKit

final class ShowManagerModule {
    private init() {}

    static func setupModule(for show: WatchedShowEntity) -> BaseView {
        let initialView = R.storyboard.showManager().instantiateInitialViewController()
        guard let showManagerView = initialView as? ShowManagerViewController else {
            fatalError("topViewController should be an instance of ShowsManagerViewController")
        }

        let creator = ShowManageriOSModuleCreator(show: show)
        let dataSource = ShowManagerDefaultDataSource(show: show, creator: creator, userDefaults: UserDefaults.standard)
        let presenter = ShowManagerDefaultPresenter(view: showManagerView, dataSource: dataSource)

        showManagerView.presenter = presenter

        return showManagerView
    }
}
