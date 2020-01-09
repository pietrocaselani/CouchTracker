public struct SyncOptions: Hashable {
  public static let defaultOptions = SyncOptions()

  public let watchedProgress: WatchedProgressOptions

  public init(watchedProgress: WatchedProgressOptions = WatchedProgressOptions()) {
    self.watchedProgress = watchedProgress
  }
}

public struct WatchedProgressOptions: Hashable {
  public let hidden: Bool
  public let specials: Bool
  public let countSpecials: Bool

  public init(hidden: Bool = false, specials: Bool = false, countSpecials: Bool = false) {
    self.hidden = hidden
    self.specials = specials
    self.countSpecials = countSpecials
  }
}
