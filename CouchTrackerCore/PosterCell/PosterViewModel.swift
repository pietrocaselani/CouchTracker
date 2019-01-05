public struct PosterViewModel: Hashable {
  public let title: String
  public let type: PosterViewModelType?

  public init(title: String, type: PosterViewModelType?) {
    self.title = title
    self.type = type
  }

  public static func == (lhs: PosterViewModel, rhs: PosterViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public var hashValue: Int {
    var hash = title.hashValue
    type.run { hash ^= $0.hashValue }
    return hash
  }
}
