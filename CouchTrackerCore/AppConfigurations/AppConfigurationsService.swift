import Moya
import RxSwift
import TraktSwift

public final class AppConfigurationsService: AppConfigurationsInteractor {
    private let repository: AppConfigurationsRepository
    private let output: AppConfigurationsOutput

    public init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput) {
        self.repository = repository
        self.output = output
    }

    public func fetchAppConfigurationsState() -> Observable<AppConfigurationsState> {
        let loginStateObservable = fetchLoginState()
        let hideSpecialsObservable = fetchHideSpecials()

        return Observable.combineLatest(loginStateObservable, hideSpecialsObservable) { loginState, hideSpecials in
            AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
        }.catchErrorJustReturn(AppConfigurationsState.initialState())
            .do(onNext: { newState in
                self.output.newConfiguration(state: newState)
            })
    }

    public func toggleHideSpecials() -> Completable {
        return repository.toggleHideSpecials()
    }

    private func fetchLoginState() -> Observable<LoginState> {
        return repository.fetchLoginState()
    }

    private func fetchHideSpecials() -> Observable<Bool> {
        return repository.fetchHideSpecials()
    }
}
