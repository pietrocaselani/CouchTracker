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

import ObjectMapper

public struct TraktDateTransformer: TransformType {
  public typealias Object = Date
  public typealias JSON = String

  public static let dateTimeTransformer = TraktDateTransformer(format: "yyyy-MM-dd'T'HH:mm:ss.000Z")
  public static let dateTransformer = TraktDateTransformer(format: "yyyy-MM-dd")

  public let dateFormatter: DateFormatter

  private init(format: String) {
    dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = format
  }

  public func transformFromJSON(_ value: Any?) -> Date? {
    if let stringDate = value as? String {
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
