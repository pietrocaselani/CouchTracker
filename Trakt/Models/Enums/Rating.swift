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

public enum Rating: Int, Equatable {
  case weaksauce = 1
  case terrible = 2
  case bad = 3
  case poor = 4
  case meh = 5
  case fair = 6
  case good = 7
  case great = 8
  case superb = 9
  case totallyninja = 10

  public static func ==(lhs: Rating, rhs: Rating) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}
