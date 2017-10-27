import Trakt
import Foundation

extension Trakt: TraktProvider {
  var oauth: URL? { return self.oauthURL }

  var isAuthenticated: Bool {
    return self.hasValidToken
  }
}
