import Foundation

extension TVDB {
  // swiftlint:disable force_unwrapping
  public static let baseURL = URL(string: "https://\(TVDB.apiHost)/")!
  public static let bannersImageURL = URL(string: "https://www.thetvdb.com/banners/")!
  public static let smallBannersImageURL = URL(string: "https://www.thetvdb.com/banners/_cache/")!
  // swiftlint:enable force_unwrapping

  static let apiHost = "api.thetvdb.com"
  static let apiVersion = "2.1.2"
  static let acceptValue = "application/vnd.thetvdb.v\(TVDB.apiVersion)"
  static let accessTokenKey = "tvdb_token"
  static let accessTokenDateKey = "tvdb_token_date"
  static let headerContentType = "Content-type"
  static let headerAccept = "Accept"
  static let contentTypeJSON = "application/json"
}
