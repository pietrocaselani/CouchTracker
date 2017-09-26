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

import Moya
import RxSwift

extension RxMoyaProvider {
  func requestData(_ token: Target) -> Observable<NSData> {
    return self.request(token).map { $0.data as NSData }
  }

  func requestDataSafety(_ token: Target) -> Observable<NSData> {
    return self.request(token).filterSuccessfulStatusAndRedirectCodes().map { $0.data as NSData }
  }
}
