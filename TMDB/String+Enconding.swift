import Foundation

extension String {
  public var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
  }

  public var utf8Encoded: Data {
    return self.data(using: .utf8) ?? Data()
  }
}
