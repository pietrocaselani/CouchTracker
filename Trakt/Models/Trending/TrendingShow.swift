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

public final class TrendingShow: BaseTrendingEntity {
  public let show: Show
  
  public required init(map: Map) throws {
    self.show = try map.value("show")
    try super.init(map: map)
  }
  
  public override var hashValue: Int {
    return super.hashValue ^ show.hashValue
  }
}
