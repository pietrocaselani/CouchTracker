private let accessTokenKey = "tvdb_token"
private let accessTokenDateKey = "tvdb_token_date"

public struct TokenManager {
  public enum TokenStatus {
    case valid(TVDBToken)
    case refresh(TVDBToken)
    case invalid

    var token: TVDBToken? {
      switch self {
      case .invalid: return nil
      case let .valid(token),
           let .refresh(token): return token
      }
    }
  }

  let tokenStatus: () -> TokenStatus
  let saveToken: (TVDBToken) -> Void

  init(
    tokenStatus: @escaping () -> TokenStatus,
    saveToken: @escaping  (TVDBToken) -> Void
  ) {
    self.tokenStatus = tokenStatus
    self.saveToken = saveToken
  }

  public static func from(
    userDefaults: UserDefaults,
    date: @escaping () -> Date
  ) -> TokenManager {
    .init(
      tokenStatus: {
        let tokenData = userDefaults.object(forKey: accessTokenKey) as? Data

        let token = tokenData.flatMap {
          try? NSKeyedUnarchiver.unarchivedObject(ofClass: SecureToken.self, from: $0)
        }
        .map(\.token)
        .map(TVDBToken.init(token:))

        guard let validToken = token else { return TokenStatus.invalid }

        let tokenDate = userDefaults.object(forKey: accessTokenDateKey) as? Date

        guard let validTokenDate = tokenDate else { return TokenStatus.refresh(validToken) }

        let diff = date().timeIntervalSince1970 - validTokenDate.timeIntervalSince1970

        return diff < 82800 ? TokenStatus.valid(validToken) : TokenStatus.refresh(validToken)
      },
      saveToken: { (token: TVDBToken) in
        let secureToken = SecureToken(token: token.token)

        let tokenData = try? NSKeyedArchiver.archivedData(
          withRootObject: secureToken,
          requiringSecureCoding: true
        )

        guard let data = tokenData else { return }

        userDefaults.set(data, forKey: accessTokenKey)
        userDefaults.set(date(), forKey: accessTokenDateKey)
      }
    )
  }
}

public struct TVDBToken: Decodable {
  let token: String
}

@objc(ObjcSecureToken)
private final class SecureToken: NSObject, NSSecureCoding {
  static var supportsSecureCoding: Bool = true
  let token: String

  init(token: String) {
    self.token = token
  }

  init?(coder: NSCoder) {
    guard let string = coder.decodeObject() as? String else {
      return nil
    }

    self.token = string
  }

  func encode(with coder: NSCoder) {
    coder.encode(token)
  }
}
