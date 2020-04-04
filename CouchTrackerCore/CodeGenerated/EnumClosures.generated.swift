// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - EnumClosures

public extension MovieDetailsViewState {
  func onLoading(_ action: () -> Void) {
    guard case .loading = self else { return }
    action()
  }
  func onShowing(_ action: (MovieEntity) -> Void) {
    guard case let .showing(movie) = self else { return }
    action(movie)
  }
  func onError(_ action: (Error) -> Void) {
    guard case let .error(error) = self else { return }
    action(error)
  }
}
public extension MoviesManagerViewState {
  func onLoading(_ action: () -> Void) {
    guard case .loading = self else { return }
    action()
  }
  func onShowing(_ action: ([ModulePage], Int) -> Void) {
    guard case let .showing(pages, selectedIndex) = self else { return }
    action(pages, selectedIndex)
  }
}
