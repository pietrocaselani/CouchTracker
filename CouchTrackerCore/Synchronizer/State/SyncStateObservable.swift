import RxSwift

public protocol SyncStateObservable {
  func observe() -> Observable<SyncState>
}
