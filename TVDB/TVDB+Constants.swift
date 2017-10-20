import Foundation

extension TVDB {
  public static let baseURL = URL(string: "https://\(TVDB.apiHost)/")!
  public static let bannersImageURL = URL(string: "https://www.thetvdb.com/banners/")!
  public static let smallBannersImageURL = URL(string: "https://www.thetvdb.com/banners/_cache/")!

  static let apiHost = "api.thetvdb.com"
  static let apiVersion = "2.1.2"
  static let acceptValue = "application/vnd.thetvdb.v\(TVDB.apiVersion)"
  static let accessTokenKey = "tvdb_token"
  static let headerContentType = "Content-type"
  static let headerAccept = "Accept"
  static let contentTypeJSON = "application/json"

}
