import RxSwift

public final class AppConfigurationsStore: AppConfigurationsObservable, AppConfigurationsOutput {
  private let subject = PublishSubject<AppConfigurationsState>()

  public init() {}

  public func observe() -> Observable<AppConfigurationsState> {
    return subject.asObservable().distinctUntilChanged()
  }

  public func newConfiguration(state: AppConfigurationsState) {
    subject.onNext(state)
  }
}
