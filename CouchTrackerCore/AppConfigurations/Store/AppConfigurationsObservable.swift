import RxSwift

public protocol AppConfigurationsObservable {
  func observe() -> Observable<AppConfigurationsState>
}
