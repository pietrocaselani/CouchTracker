import RxSwift

final class TraktLoginObservableMock: TraktLoginObservable {
  let stateSubject: BehaviorSubject<TraktLoginState>

  init(state: TraktLoginState) {
    self.stateSubject = BehaviorSubject(value: state)
  }

  func observe() -> Observable<TraktLoginState> {
    return stateSubject.asObservable()
  }
}
