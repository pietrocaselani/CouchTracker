import TraktSwift
import Foundation

extension Trakt: TraktProvider {
	var oauth: URL? { return self.oauthURL }
}

extension Trakt: TraktAuthenticationProvider {
  var isAuthenticated: Bool { return self.hasValidToken }
}
