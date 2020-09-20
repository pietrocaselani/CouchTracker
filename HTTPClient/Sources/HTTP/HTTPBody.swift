public struct HTTPBody: Equatable {
    public static let empty = HTTPBody(isEmpty: true, additionalHeaders: [:], encode: { Data() })

    public let isEmpty: Bool
    public let additionalHeaders: [String: String]
    public let encode: () throws -> Data

    public static func == (lhs: HTTPBody, rhs: HTTPBody) -> Bool {
        let lhsData = try? lhs.encode()
        let rhsData = try? rhs.encode()

        return lhsData == rhsData &&
            lhs.isEmpty == rhs.isEmpty &&
            lhs.additionalHeaders == rhs.additionalHeaders
    }

    public static func encodableModel<Model: Encodable>(
        encoder: JSONEncoder = .init(),
        value: Model
    ) -> HTTPBody {
        .init(
            isEmpty: false,
            additionalHeaders: ["Content-Type": "application/json; charset=utf-8"],
            encode: {
                try encoder.encode(value)
            }
        )
    }

    public static func data(
        _ data: Data
    ) -> HTTPBody {
        .init(
            isEmpty: data.isEmpty,
            additionalHeaders: [:],
            encode: { data }
        )
    }
}
