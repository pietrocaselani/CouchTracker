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
