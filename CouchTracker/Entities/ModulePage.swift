struct ModulePage: Hashable {
  let page: BaseView
  let title: String

  var hashValue: Int {
    return title.hashValue
  }

  static func == (lhs: ModulePage, rhs: ModulePage) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
