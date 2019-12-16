import Moya

final class TraktTokenInterceptor: RequestInterceptor {
  private weak var trakt: Trakt?

  init(trakt: Trakt) {
    self.trakt = trakt
  }

  func intercept<T>(target _: T.Type, endpoint: Endpoint,
                    done: @escaping MoyaProvider<T>.RequestResultClosure) where T: TraktType {
    guard let trakt = self.trakt else {
      done(.failure(MoyaError.requestMapping(endpoint.url)))
      return
    }

    guard let request = try? endpoint.urlRequest() else {
      done(.failure(MoyaError.requestMapping(endpoint.url)))
      return
    }

    if request.url?.path.contains("oauth/token") ?? false {
      done(.success(request))
      return
    }

    if trakt.hasValidToken {
      done(.success(request))
      return
    }

    let tokenCompletion = { (result: Result<Token, MoyaError>) -> Void in
      switch result {
      case let .success(newToken):
        trakt.accessToken = newToken
        done(.success(request))
      case let .failure(error):
        done(.failure(error))
      }
    }

    if let currentToken = trakt.accessToken {
      refreshToken(trakt: trakt, token: currentToken, completion: tokenCompletion)
    } else {
      guard let oauthToken = trakt.oauthCode else {
        done(.success(request))
        return
      }

      fetchToken(trakt: trakt, oauthCode: oauthToken, completion: tokenCompletion)
    }
  }

  private func fetchToken(trakt: Trakt, oauthCode: String, completion: @escaping (Result<Token, MoyaError>) -> Void) {
    guard let clientSecret = trakt.credentials.clientSecret else {
      completion(.failure(MoyaError.requestMapping("Invalid client secret")))
      return
    }

    guard let redirectURL = trakt.credentials.redirectURL else {
      completion(.failure(MoyaError.requestMapping("Invalid redirect url")))
      return
    }

    let target = Authentication.accessToken(code: oauthCode,
                                            clientId: trakt.credentials.clientId,
                                            clientSecret: clientSecret,
                                            redirectURL: redirectURL,
                                            grantType: "authorization_code")

    requestToken(trakt: trakt, target: target, completion: completion)
  }

  private func refreshToken(trakt: Trakt, token: Token, completion: @escaping (Result<Token, MoyaError>) -> Void) {
    guard let clientSecret = trakt.credentials.clientSecret else {
      completion(.failure(MoyaError.requestMapping("Invalid client secret")))
      return
    }

    guard let redirectURL = trakt.credentials.redirectURL else {
      completion(.failure(MoyaError.requestMapping("Invalid redirect url")))
      return
    }

    let target = Authentication.refreshToken(refreshToken: token.refreshToken,
                                             clientId: trakt.credentials.clientId,
                                             clientSecret: clientSecret,
                                             redirectURL: redirectURL,
                                             grantType: "refresh_token")

    requestToken(trakt: trakt, target: target, completion: completion)
  }

  private func requestToken(trakt: Trakt, target: Authentication,
                            completion: @escaping (Result<Token, MoyaError>) -> Void) {
    trakt.authentication.request(target) { result in
      switch result {
      case let .success(response):
        do {
          let token = try response.filterSuccessfulStatusAndRedirectCodes().map(Token.self)
          completion(.success(token))
        } catch {
          guard let moyaError = error as? MoyaError else { return }
          completion(.failure(moyaError))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
