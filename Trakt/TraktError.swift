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

public enum TraktError: Error, Hashable {
  case cantAuthenticate(message: String)
  case authenticateError(statusCode: Int, response: String?)

  public var hashValue: Int {
    var hash = self.localizedDescription.hashValue

    switch self {
    case .cantAuthenticate(let message):
      hash ^= message.hashValue
    case .authenticateError(let statusCode, let response):
      if let responseHash = response?.hashValue {
        hash ^= responseHash
      }
      hash ^= statusCode.hashValue
    }

    return hash
  }

  public static func == (lhs: TraktError, rhs: TraktError) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
