import RxSwift

public final class AppConfigurationsDefaultPresenter: AppConfigurationsPresenter {
  private let viewStateSubject = BehaviorSubject<AppConfigurationsViewState>(value: .loading)
  private let disposeBag = DisposeBag()
  private let schedulers: Schedulers
  private let interactor: AppConfigurationsInteractor
  private let router: AppConfigurationsRouter

  public init(interactor: AppConfigurationsInteractor,
              router: AppConfigurationsRouter,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.interactor = interactor
    self.router = router
    self.schedulers = schedulers
  }

  public func viewDidLoad() {
    updateView()
  }

  public func observeViewState() -> Observable<AppConfigurationsViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func select(configuration: AppConfigurationViewModel) {
    switch configuration.value {
    case .none: break
    case let .externalURL(url):
      router.showExternal(url: url)
    case let .traktLogin(wantsToLogin):
      if wantsToLogin {
        router.showTraktLogin(output: self)
      }
    case .hideSpecials:
      interactor.toggleHideSpecials().subscribe().disposed(by: disposeBag)
    }
  }

  private func updateView() {
    interactor.fetchAppConfigurationsState()
      .map { state -> AppConfigurationsViewState in
        let viewModel = AppConfigurationsViewModelMapper.createViewModel(state)
        return AppConfigurationsViewState.showing(configs: viewModel)
      }.observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] newViewState in
        self?.viewStateSubject.onNext(newViewState)
      }, onError: { [weak self] error in
        self?.router.showError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }
}

extension AppConfigurationsDefaultPresenter: TraktLoginOutput {
  public func loggedInSuccessfully() {
    updateView()
  }

  public func logInFail(message: String) {
    router.showError(message: message)
  }
}

private enum AppConfigurationsViewModelMapper {
  fileprivate static func createViewModel(_ state: AppConfigurationsState) -> [AppConfigurationsViewModel] {
    let traktConfigs = traktConfigurationsViewModel(state: state)
    let generalConfigs = generalConfigurationsViewModel(state: state)
    let otherConfigs = otherConfigurationsViewModel()

    return [traktConfigs, generalConfigs, otherConfigs]
  }

  fileprivate static func traktConfigurationsViewModel(state: AppConfigurationsState) -> AppConfigurationsViewModel {
    let loginState = state.loginState

    let connectedConfiguration: AppConfigurationViewModel

    if case let .logged(settings) = loginState {
      connectedConfiguration = AppConfigurationViewModel(title: "Connected".localized,
                                                         subtitle: settings.user.name,
                                                         value: .none)
    } else {
      connectedConfiguration = AppConfigurationViewModel(title: "Connect to Trakt".localized,
                                                         subtitle: nil,
                                                         value: .traktLogin(wantsToLogin: true))
    }

    let configurations = [connectedConfiguration]

    return AppConfigurationsViewModel(title: "Trakt", configurations: configurations)
  }

  fileprivate static func otherConfigurationsViewModel() -> AppConfigurationsViewModel {
    let value = AppConfigurationViewModelValue.externalURL(url: Constants.githubURL)
    let appOnGithub = AppConfigurationViewModel(title: "\(Constants.appName) on GitHub", subtitle: nil, value: value)
    return AppConfigurationsViewModel(title: "Other", configurations: [appOnGithub])
  }

  fileprivate static func generalConfigurationsViewModel(state: AppConfigurationsState) -> AppConfigurationsViewModel {
    let value = AppConfigurationViewModelValue.hideSpecials(wantsToHideSpecials: state.hideSpecials)
    let hideSpecialConfiguration = AppConfigurationViewModel(title: "Hide specials",
                                                             subtitle: "Will not show special episodes",
                                                             value: value)

    return AppConfigurationsViewModel(title: "General", configurations: [hideSpecialConfiguration])
  }
}
