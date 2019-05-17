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
    if let stringDate = value {
      let resultDate = dateFormatter.date(from: stringDate)
      return resultDate
    }

    return nil
  }

  public func transformToJSON(_ value: Date?) -> String? {
    if let date = value {
      return dateFormatter.string(from: date)
    }

    return nil
  }
}
