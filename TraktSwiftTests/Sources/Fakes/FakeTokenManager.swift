@testable import TraktSwift

extension TokenManager {
  static func inMemory(
    date: @escaping () -> Date
  ) -> Self {
    var expirationDate: Date?
    var token: Token?

    return .init(
      tokenStatus: {
        guard let validToken = token else {
          return .invalid
        }

        guard let expireDate = expirationDate else {
          return .refresh(validToken)
        }

        let now = date()
        let result = expireDate.compare(now)

        return result == .orderedDescending ?
          TokenStatus.valid(validToken) : TokenStatus.refresh(validToken)
      },
      saveToken: { newToken -> Result<Token, Error> in
        expirationDate = date().addingTimeInterval(newToken.expiresIn)
        token = newToken
        return .success(newToken)
      }
    )
  }
}
