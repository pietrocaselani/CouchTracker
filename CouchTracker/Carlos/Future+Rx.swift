import PiedPiper
import RxSwift

extension Future {

  func asSingle() -> Single<T> {
    return asObservable().asSingle()
  }

  func asCompletable() -> Completable {
    return Completable.create { observer -> Disposable in
      self.onCompletion { result  in
        switch result {
        case .cancelled, .success:
          observer(.completed)
        case .error(let error):
          observer(.error(error))
        }
      }

      return Disposables.create {
        self.cancel()
      }
    }
  }

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
