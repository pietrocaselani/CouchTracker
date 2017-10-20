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

public final class ImageSizes: ImmutableMappable, Hashable {
  public let full: String

  public init(map: Map) throws {
    self.full = try map.value("full")
  }

  public func mapping(map: Map) {
    full >>> map["full"]
  }

  public var hashValue: Int {
    return full.hashValue
  }

  public static func == (lhs: ImageSizes, rhs: ImageSizes) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
