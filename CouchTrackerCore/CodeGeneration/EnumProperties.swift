/*
 Given the following enum

 ```
 enum ViewState<T>: EnumProperties {
 case start(T)
 case loading
 case completed(Int, String)
 }
 ```

 will generate the following code

 ```
 extension ViewState {
    internal var isStart: Bool {
        guard case .start = self else { return false }
        return true
    }
    internal var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }
    internal var isCompleted: Bool {
        guard case .completed = self else { return false }
        return true
    }

    internal var start: T? {
        guard case let .start(data) = self else { return nil }
        return (data)
    }
    internal var completed: (count: Int, message: String)? {
        guard case let .completed(count, message) = self else { return nil }
        return (count, message)
    }
 }
 ```
 */
public protocol EnumProperties {}
