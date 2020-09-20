public func couchTrackerAppImage(named name: String,
                                 bundleProvider: BundleProvider = CouchTrackerAppBundleProvider.instance,
                                 compatibleWith traits: UITraitCollection? = nil) -> UIImage? {
  UIImage(named: name, in: bundleProvider.bundle, compatibleWith: traits)
}


public enum Images {
  //	swiftlint:disable force_unwrapping
  public static func filter() -> UIImage {
    couchTrackerAppImage(named: "Filter")!
  }

  public static func direction() -> UIImage {
    couchTrackerAppImage(named: "Direction")!
  }

  public static func posterPlacehoder() -> UIImage {
    couchTrackerAppImage(named: "PosterPlacehoder")!
  }

  public static func backdropPlaceholder() -> UIImage {
    couchTrackerAppImage(named: "BackdropPlaceholder")!
  }
}
