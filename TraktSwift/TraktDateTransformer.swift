import Foundation

public struct TraktDateTransformer {
  public static let dateTimeTransformer = TraktDateTransformer(format: "yyyy-MM-dd'T'HH:mm:ss.000Z")
  public static let dateTransformer = TraktDateTransformer(format: "yyyy-MM-dd")

  public let dateFormatter: DateFormatter

  private init(format: String) {
    dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = format
  }

  public func transformFromJSON(_ value: String?) -> Date? {
    guard let stringDate = value else { return nil }
    return dateFormatter.date(from: stringDate)
  }

  public func transformToJSON(_ value: Date?) -> String? {
    guard let date = value else { return nil }
    return dateFormatter.string(from: date)
  }
}
