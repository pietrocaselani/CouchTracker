import RxSwift
import TraktSwift

public final class AppStateDefaultPresenter: AppStatePresenter {
  private let viewStateSubject = BehaviorSubject<AppStateViewState>(value: .loading)
  private let disposeBag = DisposeBag()
  private let schedulers: Schedulers
  private let interactor: AppStateInteractor
  private let router: AppStateRouter
  private let appStateObservable: AppStateObservable

  public init(interactor: AppStateInteractor,
              router: AppStateRouter,
              appStateObservable: AppStateObservable,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.interactor = interactor
    self.router = router
    self.schedulers = schedulers
    self.appStateObservable = appStateObservable
  }

  public func viewDidLoad() {
    updateView()
  }

  public func observeViewState() -> Observable<AppStateViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func select(configuration: AppConfigurationViewModel) {
    switch configuration.value {
    case .none: break
    case let .externalURL(url):
      router.showExternal(url: url)
    case let .traktLogin(wantsToLogin):
      if wantsToLogin {
        performLogin()
      }
    case .hideSpecials:
      interactor.toggleHideSpecials().subscribe().disposed(by: disposeBag)
    }
  }

  private func updateView() {
    interactor.fetchAppState()
      .observeOn(schedulers.mainScheduler)
      .map { state -> AppStateViewState in
        let viewModel = AppStateViewModelMapper.createViewModel(state)
        return AppStateViewState.showing(configs: viewModel)
      }.observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] newViewState in
        self?.viewStateSubject.onNext(newViewState)
      }, onError: { [weak self] error in
        self?.router.showError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }

  private func performLogin() {
    router.showTraktLogin()

    appStateObservable.observe()
      .filter { $0.isLogged }
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] _ in
        self?.router.finishLogin()
      }).disposed(by: disposeBag)
  }
}

private enum AppStateViewModelMapper {
  fileprivate static func createViewModel(_ state: AppState) -> [AppStateViewModel] {
    let traktConfigs = traktConfigurationsViewModel(state: state)
    let generalConfigs = generalConfigurationsViewModel(state: state)
    let otherConfigs = otherConfigurationsViewModel()

    return [traktConfigs, generalConfigs, otherConfigs]
  }

  fileprivate static func traktConfigurationsViewModel(state: AppState) -> AppStateViewModel {
    let connectedConfiguration: AppConfigurationViewModel

    if let settings = state.userSettings {
      connectedConfiguration = AppConfigurationViewModel(title: "Connected".localized,
                                                         subtitle: settings.user.name,
                                                         value: .none)
    } else {
      connectedConfiguration = AppConfigurationViewModel(title: "Connect to Trakt".localized,
                                                         subtitle: nil,
                                                         value: .traktLogin(wantsToLogin: true))
    }

    let configurations = [connectedConfiguration]

    return AppStateViewModel(title: "Trakt", configurations: configurations)
  }

  fileprivate static func otherConfigurationsViewModel() -> AppStateViewModel {
    let value = AppConfigurationViewModelValue.externalURL(url: Constants.githubURL)
    let appOnGithub = AppConfigurationViewModel(title: "\(Constants.appName) on GitHub", subtitle: nil, value: value)
    return AppStateViewModel(title: "Other", configurations: [appOnGithub])
  }

  fileprivate static func generalConfigurationsViewModel(state: AppState) -> AppStateViewModel {
    let value = AppConfigurationViewModelValue.hideSpecials(wantsToHideSpecials: state.hideSpecials)
    let hideSpecialConfiguration = AppConfigurationViewModel(title: "Hide specials",
                                                             subtitle: "Will not show special episodes",
                                                             value: value)

    return AppStateViewModel(title: "General", configurations: [hideSpecialConfiguration])
  }
}
