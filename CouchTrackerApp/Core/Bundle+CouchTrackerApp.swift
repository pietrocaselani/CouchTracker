import CouchTrackerCore

extension Bundle {
  //	swiftlint:disable force_unwrapping
  public static let couchTrackerApp = Bundle(identifier: "io.github.pietrocaselani.CouchTrackerApp")!
  //	swiftlint:enable force_unwrapping
}

public final class CouchTrackerAppBundleProvider: BundleProvider {
  public static let instance = CouchTrackerAppBundleProvider()
  public var bundle = Bundle.couchTrackerApp

  private init() {}
}

public func couchTrackerAppImage(named name: String,
                                 bundleProvider: BundleProvider = CouchTrackerAppBundleProvider.instance,
                                 compatibleWith traits: UITraitCollection? = nil) -> UIImage? {
  UIImage(named: name, in: bundleProvider.bundle, compatibleWith: traits)
}
