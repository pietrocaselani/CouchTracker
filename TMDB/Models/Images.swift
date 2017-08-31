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

public final class Images: ImmutableMappable {
  public let id: Int
  public let backdrops: [Image]
  public let posters: [Image]

  public init(map: Map) throws {
    self.id = try map.value("id")
    self.backdrops = try map.value("backdrops")
    self.posters = try map.value("posters")
  }
}
