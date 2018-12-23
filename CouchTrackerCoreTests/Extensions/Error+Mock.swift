import CouchTrackerCore

extension Error {
  static func mock() -> Error {
    return TraktError.loginRequired
  }
}
