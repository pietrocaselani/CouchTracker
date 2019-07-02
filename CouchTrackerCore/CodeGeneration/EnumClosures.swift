/*
 Given the following enum

 ```
 enum ViewState<T>: EnumClosures {
    case start(data: T)
    case loading
    case completed(count: Int, message: String)
}
 ```

 will generate the following code

 ```
 extension ViewState {
    internal func onStart(_ fn: (T) -> Void) {
        guard case let .start(data) = self else { return }
        fn(data)
    }
    internal func onLoading(_ fn: () -> Void) {
        guard case .loading = self else { return }
        fn()
    }
    internal func onCompleted(_ fn: (Int, String) -> Void) {
        guard case let .completed(count, message) = self else { return }
        fn(count, message)
    }
}
 ```
 */
public protocol EnumClosures {}
