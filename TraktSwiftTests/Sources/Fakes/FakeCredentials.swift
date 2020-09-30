import TraktSwift

let fakeClientID = "fake-client-id"
let fakeClientSecret = "fake-client-secret"
let fakeRedirectURL = URL(string: "couchtracker://fake-url")!

extension Trakt.Credentials {
  static let fakeNoAuth = Trakt.Credentials(
    clientId: fakeClientID,
    authData: nil
  )

  static let fakeAuth = Trakt.Credentials(
    clientId: fakeClientID,
    authData: .fake
  )
}

extension Trakt.AuthData {
  static let fake = Trakt.AuthData(
    clientSecret: fakeClientSecret,
    redirectURL: fakeRedirectURL
  )
}

extension Token {
  static func fake(
    accessToken: String = "fake-access-token",
    expiresIn: TimeInterval = 7200,
    refreshToken: String = "fake-refresh-token",
    tokenType: String = "fake-type",
    scope: String = "fake-scope"
  ) -> Token {
    .init(
      accessToken: accessToken,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
      tokenType: tokenType,
      scope: scope
    )
  }
}
