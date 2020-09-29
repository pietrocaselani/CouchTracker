private let tokenKey = "trakt_token"
private let tokenExperirationDateKey = "trakt_token_experiration_date"

public struct TokenManager {
  public enum TokenStatus: Equatable {
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
  let saveToken: (Token) -> Result<Token, Error>

  init(
    tokenStatus: @escaping () -> TokenStatus,
    saveToken: @escaping  (Token) -> Result<Token, Error>
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

        let tokenDate = userDefaults.object(forKey: tokenExperirationDateKey) as? Date

        guard let experirationDate = tokenDate else { return TokenStatus.refresh(validToken) }

        let now = date()
        let result = experirationDate.compare(now)

        return result == .orderedDescending ?
          TokenStatus.valid(validToken) : TokenStatus.refresh(validToken)
      },
      saveToken: { (token: Token) -> Result<Token, Error> in
        Result {
          let tokenData = try NSKeyedArchiver.archivedData(
            withRootObject: token,
            requiringSecureCoding: true
          )

          let experirationDate = Date(
            timeIntervalSince1970: date().timeIntervalSince1970 + token.expiresIn
          )

          userDefaults.set(tokenData, forKey: tokenKey)
          userDefaults.set(experirationDate, forKey: tokenExperirationDateKey)

          return token
        }
      }
    )
  }
}
