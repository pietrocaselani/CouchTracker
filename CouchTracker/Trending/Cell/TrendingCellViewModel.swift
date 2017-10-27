struct TrendingCellViewModel: Hashable {
  let title: String

  var hashValue: Int {
    return title.hashValue
  }

  static func == (lhs: TrendingCellViewModel, rhs: TrendingCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
