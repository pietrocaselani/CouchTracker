import Moya
import RxSwift

extension MoyaProvider {
  func requestData(_ token: Target) -> Single<NSData> {
    return self.rx.request(token).map { $0.data as NSData }
  }

  func requestDataSafety(_ token: Target) -> Single<NSData> {
    return self.rx.request(token).filterSuccessfulStatusAndRedirectCodes().map { $0.data as NSData }
  }
}
