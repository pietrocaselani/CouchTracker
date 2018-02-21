import UIKit
import CouchTrackerCore

final class ShowManagerModule {
	private init() {}

	static func setupModule(for show: WatchedShowEntity) -> BaseView {
		let initialView = R.storyboard.showManager().instantiateInitialViewController()
		guard let showManagerView = initialView as? ShowManagerViewController else {
			fatalError("topViewController should be an instance of ShowsManagerViewController")
		}

		let dataSource = ShowManageriOSModuleSetup(show: show)
		let presenter = ShowManagerDefaultPresenter(view: showManagerView, dataSource: dataSource)

		showManagerView.presenter = presenter

		return showManagerView
	}
}
