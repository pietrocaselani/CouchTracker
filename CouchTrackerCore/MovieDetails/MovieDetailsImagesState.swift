public enum MovieDetailsImagesState: Hashable {
  case loading
  case showing(images: ImagesViewModel)
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading:
      hasher.combine("MovieDetailsImagesState.loading")
    case let .showing(images):
      hasher.combine("MovieDetailsImagesState.showing")
      hasher.combine(images)
    case let .error(error):
      hasher.combine("MovieDetailsImagesState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: MovieDetailsImagesState, rhs: MovieDetailsImagesState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, loading): return true
    case let (.showing(lhsImages), showing(rhsImages)): return lhsImages == rhsImages
    case let (.error(lhsError), error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
