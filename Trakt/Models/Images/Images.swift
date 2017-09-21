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

public final class Images: ImmutableMappable, Hashable {
  public let avatar: ImageSizes

  public init(map: Map) throws {
    self.avatar = try map.value("avatar")
  }

  public func mapping(map: Map) {
    avatar >>> map["avatar"]
  }

  public var hashValue: Int {
    return avatar.hashValue
  }

  public static func ==(lhs: Images, rhs: Images) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
