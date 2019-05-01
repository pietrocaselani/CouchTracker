import CouchTrackerApp
import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let window = UIWindow()
  private let disposeBag = DisposeBag()

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    CrashReporter.initialize()

    UINavigationBar.appearance().barTintColor = Colors.NavigationBar.barTintColor
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().tintColor = Colors.NavigationBar.tintColor
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Colors.NavigationBar.titleTextColor]

    UITabBar.appearance().barTintColor = Colors.TabBar.backgroundColor
    UITabBar.appearance().tintColor = Colors.TabBar.tintColor

    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.ctzircon

    Environment.instance.syncStateObservable.observe()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { syncState in
        UIApplication.shared.isNetworkActivityIndicatorVisible = syncState.isSyncing
      }).disposed(by: disposeBag)

    let view = AppFlowModule.setupModule()

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window.rootViewController = viewController
    window.makeKeyAndVisible()

    return true
  }
}
