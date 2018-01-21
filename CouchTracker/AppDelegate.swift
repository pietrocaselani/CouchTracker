import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var listMoviesModule: TrendingModule!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().barTintColor = UIColor.ctblack
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.ctzircon]
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.ctzircon

    let view = AppFlowModule.setupModule()

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()

    return true
  }
}
