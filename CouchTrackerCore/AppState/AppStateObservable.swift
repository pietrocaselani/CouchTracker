import RxSwift

public protocol AppStateObservable {
  func observe() -> Observable<AppState>
}
