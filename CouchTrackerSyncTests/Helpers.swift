import Foundation

private final class TestableClass: NSObject {}

private let bundle = Bundle(for: TestableClass.self)

func read(file named: String) -> Data {
  bundle.url(forResource: named, withExtension: "json").map { try! Data(contentsOf: $0) }!
}

func decode<T: Codable>(file name: String, as type: T.Type) -> T {
  try! JSONDecoder().decode(type, from: read(file: name))
}
