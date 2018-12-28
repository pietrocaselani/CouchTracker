import RxSwift

public final class AppConfigurationsDefaultPresenter: AppConfigurationsPresenter {
  private weak var view: AppConfigurationsView!
  private let interactor: AppConfigurationsInteractor
  fileprivate let router: AppConfigurationsRouter
  private let disposeBag = DisposeBag()

  public init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  public func viewDidLoad() {
    updateView()
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

  fileprivate func updateView() {
    interactor.fetchAppConfigurationsState()
      .map { [unowned self] in self.createViewModel($0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] viewModel in
        self.view.showConfigurations(models: viewModel)
      }, onError: { error in
        self.router.showError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }

  private func createViewModel(_ appConfigurationsState: AppConfigurationsState) -> [AppConfigurationsViewModel] {
    let traktConfigs = traktConfigurationsViewModel(appConfigurationsState)
    let generalConfigs = generalConfigurationsViewModel(appConfigurationsState)
    let otherConfigs = otherConfigurationsViewModel()

    return [traktConfigs, generalConfigs, otherConfigs]
  }

  private func traktConfigurationsViewModel(_ state: AppConfigurationsState) -> AppConfigurationsViewModel {
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

  private func otherConfigurationsViewModel() -> AppConfigurationsViewModel {
    let value = AppConfigurationViewModelValue.externalURL(url: Constants.githubURL)
    let appOnGithub = AppConfigurationViewModel(title: "\(Constants.appName) on GitHub", subtitle: nil, value: value)
    return AppConfigurationsViewModel(title: "Other", configurations: [appOnGithub])
  }

  private func generalConfigurationsViewModel(_ state: AppConfigurationsState) -> AppConfigurationsViewModel {
    let hideSpecialConfiguration = AppConfigurationViewModel(title: "Hide specials",
                                                             subtitle: "Will not show special episodes",
                                                             value: .hideSpecials(wantsToHideSpecials: state.hideSpecials))

    return AppConfigurationsViewModel(title: "General", configurations: [hideSpecialConfiguration])
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
