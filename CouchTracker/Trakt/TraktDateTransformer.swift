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

struct TraktDateTransformer: TransformType {
  typealias Object = Date
  typealias JSON = String

  static let dateTimeTransformer = TraktDateTransformer(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'")
  static let dateTransformer = TraktDateTransformer(format: "yyyy'-'MM'-'dd")

  private let dateFormetter: DateFormatter

  private init(format: String) {
    dateFormetter = DateFormatter()
    dateFormetter.dateFormat = format
  }

  func transformFromJSON(_ value: Any?) -> Date? {
    if let stringDate = value as? String {
      return dateFormetter.date(from: stringDate)
    }

    return nil
  }

  func transformToJSON(_ value: Date?) -> String? {
    if let date = value {
      return dateFormetter.string(from: date)
    }

    return nil
  }
}
