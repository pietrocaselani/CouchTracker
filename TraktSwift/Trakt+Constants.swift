import Foundation

extension Trakt {
  // swiftlint:disable force_unwrapping
  public static let baseURL = URL(string: "https://\(Trakt.apiHost)")!
  public static let siteURL = URL(string: "https://trakt.tv")!
  // swiftlint:enable force_unwrapping

  static let OAuth2AuthorizationPath = "/oauth/authorize"
  static let OAuth2TokenPath = "/oauth/token"

  static let headerAuthorization = "Authorization"
  static let headerContentType = "Content-type"
  static let headerTraktAPIKey = "trakt-api-key"
  static let headerTraktAPIVersion = "trakt-api-version"

  static let contentTypeJSON = "application/json"
  static let apiVersion = "2"
  static let apiHost = "api.trakt.tv"

  static let accessTokenKey = "trakt_token"
  static let accessTokenDateKey = "trakt_token_date"
}
