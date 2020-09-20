import Combine

enum CouchTrackerError: Error, Hashable {
    case network(URLError)
    case unhandled(Unhandled)

    struct Unhandled: Error, Hashable {
        let error: NSError

        init(error: NSError) {
            self.error = error
        }

        init(swiftError: Error) {
            self.error = swiftError as NSError
        }
    }
}

extension Publisher {
    func mapUnhandledError() -> Publishers.MapError<Self, CouchTrackerError> {
        mapError { err -> CouchTrackerError in
            .unhandled(.init(swiftError: err))
        }
    }
}

extension Publisher where Failure == URLError {
    func mapNetworkError() -> Publishers.MapError<Self, CouchTrackerError> {
        mapError { err -> CouchTrackerError in
            .network(err)
        }
    }
}

extension URLSession {
    func dataTaskIO(for request: URLRequest) -> Publishers.MapError<DataTaskPublisher, CouchTrackerError> {
        dataTaskPublisher(for: request).mapNetworkError()
    }
}
