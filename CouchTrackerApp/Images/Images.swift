public enum Images {
  //	swiftlint:disable force_unwrapping
  public static func filter() -> UIImage {
    return couchTrackerAppImage(named: "Filter")!
  }

  public static func direction() -> UIImage {
    return couchTrackerAppImage(named: "Direction")!
  }

  public static func posterPlacehoder() -> UIImage {
    return couchTrackerAppImage(named: "PosterPlacehoder")!
  }

  public static func backdropPlaceholder() -> UIImage {
    return couchTrackerAppImage(named: "BackdropPlaceholder")!
  }
}
