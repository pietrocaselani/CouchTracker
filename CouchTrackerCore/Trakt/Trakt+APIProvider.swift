import Foundation
import TraktSwift

extension Trakt: TraktProvider {
  public var oauth: URL? { return oauthURL }
}

extension Trakt: TraktAuthenticationProvider {
  public var isAuthenticated: Bool { return hasValidToken }
}
