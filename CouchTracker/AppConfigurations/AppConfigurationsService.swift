import RxSwift
import TraktSwift
import Moya

final class AppConfigurationsService: AppConfigurationsInteractor {
	private let repository: AppConfigurationsRepository
	private let output: AppConfigurationsOutput

	init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput) {
		self.repository = repository
		self.output = output
	}

	func fetchAppConfigurationsState() -> Observable<AppConfigurationsState> {
		let loginStateObservable = fetchLoginState()
		let hideSpecialsObservable = fetchHideSpecials()

		return Observable.combineLatest(loginStateObservable, hideSpecialsObservable) { (loginState, hideSpecials) in
			AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
			}.catchErrorJustReturn(AppConfigurationsState.initialState())
			.do(onNext: { newState in
				self.output.newConfiguration(state: newState)
			})
	}

	func toggleHideSpecials() -> Completable {
		return self.repository.toggleHideSpecials()
	}

	private func fetchLoginState() -> Observable<LoginState> {
		return repository.fetchLoginState()
	}

	private func fetchHideSpecials() -> Observable<Bool> {
		return repository.fetchHideSpecials()
	}
}
