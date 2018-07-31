public struct PosterCellViewModel: Hashable {
  public let title: String

  public var hashValue: Int {
    return title.hashValue
  }

  public static func == (lhs: PosterCellViewModel, rhs: PosterCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
