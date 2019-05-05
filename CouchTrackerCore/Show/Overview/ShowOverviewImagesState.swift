public enum ShowOverviewImagesState: Hashable {
  case loading
  case empty
  case showing(images: ImagesViewModel)
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading: hasher.combine("ShowOverviewImagesState.loading")
    case .empty: hasher.combine("ShowOverviewImagesState.empty")
    case let .showing(images):
      hasher.combine("ShowOverviewImagesState.showing")
      hasher.combine(images)
    case let .error(error):
      hasher.combine("ShowOverviewImagesState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: ShowOverviewImagesState, rhs: ShowOverviewImagesState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, loading): return true
    case (.empty, empty): return true
    case let (.showing(lhsImages), showing(rhsImages)): return lhsImages == rhsImages
    case let (.error(lhsError), error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
