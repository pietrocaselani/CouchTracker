import RxSwift

protocol AppConfigurationsObservable {
	func observe() -> Observable<AppConfigurationsState>
}
