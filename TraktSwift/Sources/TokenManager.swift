private let tokenKey = "trakt_token"
private let tokenDateKey = "trakt_token_date"

public struct TokenManager {
  public enum TokenStatus {
    case valid(Token)
    case refresh(Token)
    case invalid

    var token: Token? {
      switch self {
      case .invalid: return nil
      case let .valid(token),
           let .refresh(token): return token
      }
    }
  }

  let tokenStatus: () -> TokenStatus
  let saveToken: (Token) -> Void

  init(
    tokenStatus: @escaping () -> TokenStatus,
    saveToken: @escaping  (Token) -> Void
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
        let tokenData = userDefaults.object(forKey: tokenKey) as? Data

        let token = tokenData.flatMap {
          try? NSKeyedUnarchiver.unarchivedObject(ofClass: Token.self, from: $0)
        }

        guard let validToken = token else { return TokenStatus.invalid }

        let tokenDate = userDefaults.object(forKey: tokenDateKey) as? Date

        guard let validDate = tokenDate else { return TokenStatus.refresh(validToken) }

        return validDate.compare(date()) == .orderedDescending ?
          TokenStatus.valid(validToken) : TokenStatus.refresh(validToken)
      },
      saveToken: { (token: Token) in
        let tokenData = try? NSKeyedArchiver.archivedData(
          withRootObject: token,
          requiringSecureCoding: true
        )

        guard let data = tokenData else { return }

        userDefaults.set(data, forKey: tokenKey)
        userDefaults.set(date(), forKey: tokenDateKey)
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
