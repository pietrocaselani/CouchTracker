// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - EnumProperties

public extension MovieDetailsViewState {
  var isLoading: Bool {
    guard case .loading = self else { return false }
    return true
  }
  var isShowing: Bool {
    guard case .showing = self else { return false }
    return true
  }
  var isError: Bool {
    guard case .error = self else { return false }
    return true
  }
  var showing: MovieEntity? {
    guard case let .showing(movie) = self else { return nil }
    return (movie)
  }
  var error: Error? {
    guard case let .error(error) = self else { return nil }
    return (error)
  }
}
public extension MoviesManagerViewState {
  var isLoading: Bool {
    guard case .loading = self else { return false }
    return true
  }
  var isShowing: Bool {
    guard case .showing = self else { return false }
    return true
  }
  var showing: (pages: [ModulePage], selectedIndex: Int)? {
    guard case let .showing(pages, selectedIndex) = self else { return nil }
    return (pages, selectedIndex)
  }
}
