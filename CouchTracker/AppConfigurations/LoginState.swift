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

import TraktSwift

enum LoginState: Equatable {
  case logged(user: User)
  case notLogged

  static func == (lhs: LoginState, rhs: LoginState) -> Bool {
    switch (lhs, rhs) {
    case (.logged(let lhsUser), .logged(let rhsUser)):
      return lhsUser == rhsUser
    case (.notLogged, .notLogged): return true
    default: return false
    }
  }
}
