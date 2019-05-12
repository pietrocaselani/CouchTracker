import CouchTrackerCore

public enum DebugMenuModule {
  public static func setupModule() -> BaseView {
    //	swiftlint:disable force_cast
    return UINavigationController(rootViewController: DebugMenuViewController()) as! BaseView
  }
}
