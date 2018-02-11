import RxSwift

final class AppConfigurationsStore: AppConfigurationsObservable, AppConfigurationsOutput {
  private let subject = PublishSubject<AppConfigurationsState>()

  func observe() -> Observable<AppConfigurationsState> {
    return subject.asObservable().distinctUntilChanged()
  }

  func newConfiguration(state: AppConfigurationsState) {
    subject.onNext(state)
  }
}
