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

import Foundation

extension TraktV2 {

  public static let baseURL = URL(string: "https://\(TraktV2.apiHost)")!
  public static let siteURL = URL(string: "https://trakt.tv")!

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

}
