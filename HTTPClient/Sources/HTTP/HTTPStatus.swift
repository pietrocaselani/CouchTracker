public struct HTTPStatus: RawRepresentable, Hashable {
    public typealias RawValue = Int
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension HTTPStatus {
    static let httpContinue = HTTPStatus(rawValue: 100)
    static let switchingProtocols = HTTPStatus(rawValue: 101)
    static let ok = HTTPStatus(rawValue: 200)
    static let created = HTTPStatus(rawValue: 201)
    static let accepted = HTTPStatus(rawValue: 202)
    static let nonAuthoritativeInformation = HTTPStatus(rawValue: 203)
    static let noContent = HTTPStatus(rawValue: 204)
    static let resetContent = HTTPStatus(rawValue: 205)
    static let partialContent = HTTPStatus(rawValue: 206)
    static let multipleChoices = HTTPStatus(rawValue: 300)
    static let movedPermanently = HTTPStatus(rawValue: 301)
    static let found = HTTPStatus(rawValue: 302)
    static let seeOther = HTTPStatus(rawValue: 303)
    static let notModified = HTTPStatus(rawValue: 304)
    static let useProxy = HTTPStatus(rawValue: 305)
    static let temporaryRedirect = HTTPStatus(rawValue: 307)
    static let badRequest = HTTPStatus(rawValue: 400)
    static let unauthorized = HTTPStatus(rawValue: 401)
    static let paymentRequired = HTTPStatus(rawValue: 402)
    static let forbidden = HTTPStatus(rawValue: 403)
    static let notFound = HTTPStatus(rawValue: 404)
    static let methodNotAllowed = HTTPStatus(rawValue: 405)
    static let notAcceptable = HTTPStatus(rawValue: 406)
    static let proxyAuthenticationRequired = HTTPStatus(rawValue: 407)
    static let requestTimeout = HTTPStatus(rawValue: 408)
    static let conflict = HTTPStatus(rawValue: 409)
    static let gone = HTTPStatus(rawValue: 410)
    static let lengthRequired = HTTPStatus(rawValue: 411)
    static let preconditionFailed = HTTPStatus(rawValue: 412)
    static let requestEntityTooLarge = HTTPStatus(rawValue: 413)
    static let requestURITooLong = HTTPStatus(rawValue: 414)
    static let unsupportedMediaType = HTTPStatus(rawValue: 415)
    static let requestedRangeNotSatisfiable = HTTPStatus(rawValue: 416)
    static let expectationFailed = HTTPStatus(rawValue: 417)
    static let internalServerError = HTTPStatus(rawValue: 500)
    static let notImplemented = HTTPStatus(rawValue: 501)
    static let badGateway = HTTPStatus(rawValue: 502)
    static let serviceUnavailable = HTTPStatus(rawValue: 503)
    static let gatewayTimeout = HTTPStatus(rawValue: 504)
    static let httpVersionNotSupported = HTTPStatus(rawValue: 505)

    static let allHTTPStatus: [HTTPStatus] = [
        .httpContinue,
        .switchingProtocols,
        .ok,
        .created,
        .accepted,
        .nonAuthoritativeInformation,
        .noContent,
        .resetContent,
        .partialContent,
        .multipleChoices,
        .movedPermanently,
        .found,
        .seeOther,
        .notModified,
        .useProxy,
        .temporaryRedirect,
        .badRequest,
        .unauthorized,
        .paymentRequired,
        .forbidden,
        .notFound,
        .methodNotAllowed,
        .notAcceptable,
        .proxyAuthenticationRequired,
        .requestTimeout,
        .conflict,
        .gone,
        .lengthRequired,
        .preconditionFailed,
        .requestEntityTooLarge,
        .requestURITooLong,
        .unsupportedMediaType,
        .requestedRangeNotSatisfiable,
        .expectationFailed,
        .internalServerError,
        .notImplemented,
        .badGateway,
        .serviceUnavailable,
        .gatewayTimeout,
        .httpVersionNotSupported
    ]
}
