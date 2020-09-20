public protocol HTTPMiddleware {
    func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher
}

private extension HTTPMiddleware {
    func makeResponder(chainingTo responder: HTTPResponding) -> HTTPResponding {
        MiddlewareResponder(middleware: self, responder: responder)
    }
}

private struct MiddlewareResponder: HTTPResponding {
    let middleware: HTTPMiddleware
    let responder: HTTPResponding

    func respond(to request: HTTPRequest) -> HTTPCallPublisher {
        middleware.respond(to: request, andCallNext: responder)
    }
}

extension Array where Element == HTTPMiddleware {
    func makeResponder(chainingTo responder: HTTPResponding) -> HTTPResponding {
        var responder = responder

        for middleware in reversed() {
            responder = middleware.makeResponder(chainingTo: responder)
        }

        return responder
    }
}
