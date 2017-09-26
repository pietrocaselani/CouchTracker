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

import RxSwift
import Moya

extension ObservableType where E == NSData {
  func cache(_ cache: AnyCache<Int, NSData>, key: Int) -> Observable<NSData> {
    return self.do(onNext: { data in
      _ = cache.set(data, for: key)
    })
  }
}

extension ObservableType where E == Response {
  func cache(_ cache: AnyCache<Int, NSData>, key: Int) -> Observable<Response> {
    return self.do(onNext: { response in
      _ = cache.set(response.data as NSData, for: key)
    })
  }
}
