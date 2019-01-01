import RxSwift

public final class AppConfigurationsStore: AppConfigurationsObservable, AppConfigurationsOutput {
  private let subject: BehaviorSubject<AppConfigurationsState>

  public init(appState: AppConfigurationsState) {
    subject = BehaviorSubject<AppConfigurationsState>(value: appState)
  }

  public func observe() -> Observable<AppConfigurationsState> {
    return subject.asObservable().distinctUntilChanged()
  }

  public func newConfiguration(state: AppConfigurationsState) {
    subject.onNext(state)
  }
}
