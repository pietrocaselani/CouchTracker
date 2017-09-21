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

public final class UserIds: ImmutableMappable, Hashable {
  public let slug: String

  public init(map: Map) throws {
    self.slug = try map.value("slug")
  }

  public func mapping(map: Map) {
    slug >>> map["slug"]
  }

  public var hashValue: Int {
    return slug.hashValue
  }

  public static func == (lhs: UserIds, rhs: UserIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
