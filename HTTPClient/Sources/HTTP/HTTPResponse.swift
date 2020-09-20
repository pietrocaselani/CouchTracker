public struct HTTPResponse: Equatable {
    private let response: HTTPURLResponse
    public let request: HTTPRequest
    public let body: Body
    public let status: HTTPStatus
    public let message: String

    public init(
        response: HTTPURLResponse,
        request: HTTPRequest,
        body: Data
    ) {
        self.response = response
        self.request = request
        self.body = .init(data: body)
        self.status = .init(rawValue: response.statusCode)
        self.message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] {
        response.allHeaderFields
    }

    public var url: URL? {
        response.url
    }

    public struct Body: Equatable {
        public let data: Data

        public init(data: Data) {
            self.data = data
        }

        public func asString(encoding: String.Encoding = .utf8) -> String? {
            String(data: data, encoding: encoding)
        }

        public func decodeAsModel<T: Decodable>(
            _ type: T.Type,
            using decoder: JSONDecoder = .init()
        ) throws -> T {
            try decoder.decode(type, from: data)
        }
    }
}
