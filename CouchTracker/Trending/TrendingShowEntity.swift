struct TrendingShowEntity: Hashable {
  let show: ShowEntity

  var hashValue: Int {
    return show.hashValue
  }

  static func == (lhs: TrendingShowEntity, rhs: TrendingShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
