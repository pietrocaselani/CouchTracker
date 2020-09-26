public enum TraktError: Error, Hashable {
  case failedToCreateOAuthURL
  case cantAuthenticate(message: String)
  case authenticateError(statusCode: Int, response: String?)
  case missingJSONValue(message: String)
}

public enum AuthenticationResult: Int {
  case authenticated
  case undetermined
}
