import UIKit

final class MoviesManagerModule {
	private init() {}

	static func setupModule() -> BaseView {
		guard let view = R.storyboard.moviesManager().instantiateInitialViewController() as? UINavigationController else {
			fatalError("Initial view controller from MoviesManager storyboard should be an UINavigationController")
		}

		guard let moviesManagerView = view.topViewController as? MoviesManagerView else {
			fatalError("MoviesManager storyboard should have a MoviesManagerView")
		}

		let dataSource = MoviesManageriOSModuleSetup()
		let presenter = MoviesManageriOSPresenter(view: moviesManagerView, dataSource: dataSource)

		moviesManagerView.presenter = presenter

		return view
	}
}
