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

import Foundation

struct ShowProgressViewModel: CustomStringConvertible {
  let title: String
  let nextEpisode: String?
  let networkInfo: String
  let status: String
  let tmdbId: Int?

  var description: String {
    var json = [String: Any?]()

    let mirror = Mirror(reflecting: self)
    var index = 0

    for child in mirror.children {
      let key = child.label ?? "Key\(index)"
      json[key] = child.value
      index += 1
    }

    guard JSONSerialization.isValidJSONObject(json) else { return "" }

    let options = JSONSerialization.WritingOptions.prettyPrinted
    guard let data = try? JSONSerialization.data(withJSONObject: json, options: options) else { return "" }

    return String(data: data, encoding: .utf8) ?? ""
  }
}
