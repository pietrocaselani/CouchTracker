public protocol HTTPResponding {
    func respond(to request: HTTPRequest) -> HTTPCallPublisher
}
