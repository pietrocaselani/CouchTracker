public struct PosterViewModel: Hashable {
  public let title: String
  public let type: PosterViewModelType?

  public static func == (lhs: PosterViewModel, rhs: PosterViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public var hashValue: Int {
    var hash = title.hashValue

    if let typeHash = type?.hashValue {
      hash = hash ^ typeHash
    }

    return hash
  }
}
