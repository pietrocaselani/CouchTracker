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

import PiedPiper
import RxSwift

extension Future {

  func asObservable() -> Observable<T> {
    let observable = Observable<T>.create { observer in

      self.onCompletion { (result: Result<T>) in
        switch result {
        case .cancelled:
          observer.onCompleted()
        case .success(let value):
          observer.onNext(value)
          observer.onCompleted()
        case .error(let error):
          observer.onError(error)
        }
      }

      return Disposables.create {
        self.cancel()
      }
    }

    return observable
  }

}
