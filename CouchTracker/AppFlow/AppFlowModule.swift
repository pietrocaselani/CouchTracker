import UIKit
import CouchTrackerCore

final class AppFlowModule {
	private init() {
		Swift.fatalError("No instances for you!")
	}

	static func setupModule() -> BaseView {
		guard let appFlowViewController = R.storyboard.appFlow.appFlowViewController() else {
			fatalError("Can't instantiate AppFlowViewController from Storyboard")
		}

		let repository = AppFlowUserDefaultsRepository(userDefaults: UserDefaults.standard)
		let interactor = AppFlowService(repository: repository)
		let dataSource = AppFlowiOSModuleDataSource()
		let presenter = AppFlowDefaultPresenter(view: appFlowViewController,
																																										interactor: interactor,
																																										moduleDataSource: dataSource)

		appFlowViewController.presenter = presenter

		return appFlowViewController
	}
}
