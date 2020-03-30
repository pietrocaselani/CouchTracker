import Foundation
import TraktSwift

extension Trakt: TraktProvider {
  public var oauth: URL? { oauthURL }
}

extension Trakt: TraktAuthenticationProvider {
  public var isAuthenticated: Bool { hasValidToken }
}
