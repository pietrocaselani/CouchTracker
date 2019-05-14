import Foundation

extension String {
  public var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
  }

  public var utf8Encoded: Data {
    return data(using: .utf8) ?? Data()
  }
}
