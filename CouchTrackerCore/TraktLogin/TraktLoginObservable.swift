import RxSwift

public protocol TraktLoginObservable {
	func observe() -> Observable<TraktLoginState>
}
