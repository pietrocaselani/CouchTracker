public struct PosterViewModel: Hashable {
  public let title: String
  public let type: PosterViewModelType?

  public init(title: String, type: PosterViewModelType?) {
    self.title = title
    self.type = type
  }
}
