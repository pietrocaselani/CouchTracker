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

public final class Airs: ImmutableMappable, Hashable {
  public let day: String
  public let time: String
  public let timezone: String

  public required init(map: Map) throws {
    self.day = try map.value("day")
    self.time = try map.value("time")
    self.timezone = try map.value("timezone")
  }

  public var hashValue: Int {
    return day.hashValue ^ time.hashValue ^ timezone.hashValue
  }

  public static func == (lhs: Airs, rhs: Airs) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
