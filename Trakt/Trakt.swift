/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import Moya

public final class Trakt {
  let clientId: String
  let clientSecret, redirectURL: String?
  let oauthURL: URL?
  var plugins = [PluginType]()

  public private(set) var accessToken: Token? {
    didSet {
      updateAccessTokenPlugin(accessToken)
    }
  }

  public convenience init(clientId: String) {
    self.init(clientId: clientId, clientSecret: nil, redirectURL: nil)
  }

  public init(clientId: String, clientSecret: String?, redirectURL: String?) {
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.redirectURL = redirectURL

    if let redirectURL = redirectURL {
      let url = Trakt.siteURL.appendingPathComponent(Trakt.OAuth2AuthorizationPath)
      var componenets = URLComponents(url: url, resolvingAgainstBaseURL: false)

      let responseTypeItem = URLQueryItem(name: "response_type", value: "code")
      let clientIdItem = URLQueryItem(name: "client_id", value: clientId)
      let redirectURIItem = URLQueryItem(name: "redirect_uri", value: redirectURL)
      componenets?.queryItems = [responseTypeItem, clientIdItem, redirectURIItem]

      self.oauthURL = componenets?.url
    } else {
      self.oauthURL = nil
    }

    loadToken()
  }

  public func hasValidToken() -> Bool {
    return accessToken?.expiresIn.compare(Date()) == .orderedDescending
  }

  private func loadToken() {
    let tokenData = UserDefaults.standard.object(forKey: Trakt.accessTokenKey) as? Data
    if let tokenData = tokenData, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
      self.accessToken = token
    }
  }

  private func saveToken(_ token: Token) {
    let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
    UserDefaults.standard.set(tokenData, forKey: Trakt.accessTokenKey)
  }

  private func updateAccessTokenPlugin(_ token: Token?) {
    if let index = self.plugins.index(where: { $0 is AccessTokenPlugin }) {
      plugins.remove(at: index)
    }

    if let token = token {
      plugins.append(AccessTokenPlugin(token: token.accessToken))
      saveToken(token)
    }
  }
}
