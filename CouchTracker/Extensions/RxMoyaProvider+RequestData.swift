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
