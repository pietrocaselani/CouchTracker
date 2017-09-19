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

public enum Authentication {
  case accessToken(code: String, clientId: String, clientSecret: String, redirectURL: String, grantType: String)
}

extension Authentication: TraktType {
  public var path: String {
    return Trakt.OAuth2TokenPath
  }

  public var method: Method { return .post }

  public var parameters: [String : Any]? {
    switch self {
    case .accessToken(let code, let clientId, let clientSecret, let redirectURL, let grantType):
      return ["code": code,
              "client_id": clientId,
              "client_secret": clientSecret,
              "redirect_uri": redirectURL,
              "grant_type": grantType]
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }
}
