import TraktSwift
import RxSwift

final class AppConfigurationsDefaultRepository: AppConfigurationsRepository {
	private let dataSource: AppConfigurationsDataSource
	private let network: AppConfigurationsNetwork
	private let schedulers: Schedulers
	private let disposeBag = DisposeBag()

	init(dataSource: AppConfigurationsDataSource, network: AppConfigurationsNetwork, schedulers: Schedulers) {
		self.dataSource = dataSource
		self.network = network
		self.schedulers = schedulers
	}

	func fetchLoginState() -> Observable<LoginState> {
		return dataSource.fetchLoginState()
			.do(onNext: { [weak self] loginState in
				if loginState == .notLogged {
					self?.saveLoginStateFromAPI()
				}
			}, onError: { [weak self] _ in
				self?.saveLoginStateFromAPI()
			})
			.catchErrorJustReturn(.notLogged)
			.ifEmpty(default: .notLogged)
			.subscribeOn(schedulers.ioScheduler)
	}

	func fetchHideSpecials() -> Observable<Bool> {
		return dataSource.fetchHideSpecials()
	}

	func toggleHideSpecials() -> Completable {
		return Completable.create(subscribe: { [unowned self] completable -> Disposable in
			do {
				try self.dataSource.toggleHideSpecials()
				completable(.completed)
			} catch {
				completable(.error(error))
			}

			return Disposables.create()
		}).subscribeOn(schedulers.ioScheduler)
	}

	private func saveLoginStateFromAPI() {
		return network.fetchUserSettings()
			.observeOn(schedulers.networkScheduler)
			.do(onSuccess: { [unowned self] settings in
				try self.dataSource.save(settings: settings)
			})
			.subscribe()
			.disposed(by: disposeBag)
	}
}
