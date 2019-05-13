public struct ModulePage: Hashable {
  public let page: BaseView
  public let title: String

  public init(page: BaseView, title: String) {
    self.page = page
    self.title = title
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(title)
  }

  public static func == (lhs: ModulePage, rhs: ModulePage) -> Bool {
    return lhs.title == rhs.title
  }
}
