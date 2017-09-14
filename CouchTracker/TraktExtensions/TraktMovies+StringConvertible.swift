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

import Carlos
import TraktSwift

extension Movies: StringConvertible {
  public func toString() -> String {
    switch self {
    case .trending(let page, let limit, _):
      return "\(self.path)-\(page)-\(limit)"
    case .summary(let movieId, let extended):
      return "\(self.path)/\(movieId)-\(extended.rawValue)"
    }
  }
}
