import UIKit
import CouchTrackerCore

final class ShowsManagerModule {
	private init() {
		fatalError("No instances for you!")
	}

	static func setupModule() -> BaseView {
		guard let view = R.storyboard.showsManager().instantiateInitialViewController() as? UINavigationController else {
			fatalError("Initial view controller from ShowsManager storyboard should be an UINavigation")
		}

		guard let showsManagerView = view.topViewController as? ShowsManagerViewController else {
			fatalError("Can't instantiate ShowsManagerViewController from Storyboard")
		}

		let moduleCreator = ShowsManageriOSCreator()
		let modulesSetup = ShowsManageriOSModuleSetup(creator: moduleCreator)
		let presenter = ShowsManageriOSPresenter(view: showsManagerView, moduleSetup: modulesSetup)

		showsManagerView.presenter = presenter

		return view
	}
}
