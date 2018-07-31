public enum MovieDetailsImagesState: Hashable {
  case loading
  case showing(images: ImagesViewModel)
  case error(error: Error)

  public var hashValue: Int {
    switch self {
    case .loading:
      return "MovieDetailsImagesState.loading".hashValue
    case let .showing(viewModel):
      return "MovieDetailsImagesState.showing".hashValue ^ viewModel.hashValue
    case let .error(error):
      return "MovieDetailsImagesState.error".hashValue ^ error.localizedDescription.hashValue
    }
  }

  public static func == (lhs: MovieDetailsImagesState, rhs: MovieDetailsImagesState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
