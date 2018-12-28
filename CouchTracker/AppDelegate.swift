import CouchTrackerApp
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let window = UIWindow()

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    UINavigationBar.appearance().barTintColor = UIColor.ctblack
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ctzircon]
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.ctzircon

    let view = AppFlowModule.setupModule()

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window.rootViewController = viewController
    window.makeKeyAndVisible()

    return true
  }
}
