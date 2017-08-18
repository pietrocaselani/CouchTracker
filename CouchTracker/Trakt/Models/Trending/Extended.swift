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

public enum Extended: String, Equatable {
  case defaultMin = "min"
  case full = "full"
  case noSeasons = "noseasons"
  case episodes = "episodes"
  case fullEpisodes = "full,episodes"

  public static func == (lhs: Extended, rhs: Extended) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}
