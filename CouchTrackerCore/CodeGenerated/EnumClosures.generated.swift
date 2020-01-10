// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// MARK: - EnumClosures

public extension MovieDetailsViewState {
    public func onLoading(_ fn: () -> Void) {
        guard case .loading = self else { return }
        fn()
    }
    public func onShowing(_ fn: (MovieEntity) -> Void) {
        guard case let .showing(movie) = self else { return }
        fn(movie)
    }
    public func onError(_ fn: (Error) -> Void) {
        guard case let .error(error) = self else { return }
        fn(error)
    }
}
public extension MoviesManagerViewState {
    public func onLoading(_ fn: () -> Void) {
        guard case .loading = self else { return }
        fn()
    }
    public func onShowing(_ fn: ([ModulePage], Int) -> Void) {
        guard case let .showing(pages, selectedIndex) = self else { return }
        fn(pages, selectedIndex)
    }
}
