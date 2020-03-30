import Foundation

public final class Token: NSObject, Codable, NSCoding {
  public let accessToken: String
  public let expiresIn: TimeInterval
  public let refreshToken: String
  public let tokenType: String
  public let scope: String

  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
    case scope
  }

  public init(accessToken: String, expiresIn: TimeInterval, refreshToken: String, tokenType: String, scope: String) {
    self.accessToken = accessToken
    self.expiresIn = expiresIn
    self.refreshToken = refreshToken
    self.tokenType = tokenType
    self.scope = scope
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    accessToken = try container.decode(String.self, forKey: .accessToken)
    refreshToken = try container.decode(String.self, forKey: .refreshToken)
    tokenType = try container.decode(String.self, forKey: .tokenType)
    scope = try container.decode(String.self, forKey: .scope)
    expiresIn = try container.decode(TimeInterval.self, forKey: .expiresIn)
  }

  public required convenience init?(coder: NSCoder) {
    let expiresIn = coder.decodeDouble(forKey: "expiresIn")

    guard let accessToken = coder.decodeObject(forKey: "accessToken") as? String,
      let refreshToken = coder.decodeObject(forKey: "refreshToken") as? String,
      let tokenType = coder.decodeObject(forKey: "tokenType") as? String,
      let scope = coder.decodeObject(forKey: "scope") as? String
      else { return nil }

    self.init(accessToken: accessToken, expiresIn: expiresIn,
              refreshToken: refreshToken, tokenType: tokenType, scope: scope)
  }

  public func encode(with coder: NSCoder) {
    coder.encode(accessToken, forKey: "accessToken")
    coder.encode(expiresIn, forKey: "expiresIn")
    coder.encode(refreshToken, forKey: "refreshToken")
    coder.encode(tokenType, forKey: "tokenType")
    coder.encode(scope, forKey: "scope")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(accessToken, forKey: .accessToken)
    try container.encode(expiresIn, forKey: .expiresIn)
    try container.encode(refreshToken, forKey: .refreshToken)
    try container.encode(tokenType, forKey: .tokenType)
    try container.encode(scope, forKey: .scope)
  }

  public override var hash: Int {
    accessToken.hashValue ^ expiresIn.hashValue ^
      refreshToken.hashValue ^ tokenType.hashValue ^ scope.hashValue
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let otherToken = object as? Token else { return false }

    return Token.areTokensEqual(lhs: self, rhs: otherToken)
  }

  private static func areTokensEqual(lhs: Token, rhs: Token) -> Bool {
    lhs.accessToken == rhs.accessToken && lhs.expiresIn == rhs.expiresIn &&
      lhs.refreshToken == rhs.refreshToken && lhs.tokenType == rhs.tokenType && lhs.scope == rhs.scope
  }
}
