import RxSwift

protocol TraktLoginObservable {
  func observe() -> Observable<TraktLoginState>
}
