public final class TraktTestableBundle {
	public static let bundle = Bundle(for: TraktTestableBundle.self)

	public static func url(forResource name: String) -> URL {
		return bundle.url(forResource: name, withExtension: "json")!
	}

	public static func data(forResource name: String) throws -> Data {
		return try Data(contentsOf: url(forResource: name))
	}

	public static func decode<T: Decodable>(resource name: String, decoder: JSONDecoder = .init()) throws -> T {
		return try decoder.decode(T.self, from: data(forResource: name))
	}
}
