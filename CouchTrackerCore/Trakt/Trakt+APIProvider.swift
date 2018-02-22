import TraktSwift
import Foundation

extension Trakt: TraktProvider {
	public var oauth: URL? { return self.oauthURL }
}

extension Trakt: TraktAuthenticationProvider {
	public var isAuthenticated: Bool { return self.hasValidToken }
}
