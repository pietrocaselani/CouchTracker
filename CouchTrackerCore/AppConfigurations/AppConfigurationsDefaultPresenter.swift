import RxSwift

public final class AppConfigurationsDefaultPresenter: AppConfigurationsPresenter {
  private weak var view: AppConfigurationsView!
  private let interactor: AppConfigurationsInteractor
  fileprivate let router: AppConfigurationsRouter
  private let disposeBag = DisposeBag()
  private var options = [AppConfigurationOptions]()

  public init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }

  public func viewDidLoad() {
    updateView()
  }

  public func optionSelectedAt(index: Int) {
    let option = options[index]
    switch option {
    case .connectToTrakt:
      router.showTraktLogin(output: self)
    case .hideSpecials:
      interactor.toggleHideSpecials().subscribe().disposed(by: disposeBag)
    default: break
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

    return [traktConfigs, generalConfigs]
  }

  private func traktConfigurationsViewModel(_ state: AppConfigurationsState) -> AppConfigurationsViewModel {
    let loginState = state.loginState

    let connectedConfiguration: AppConfigurationViewModel
    let connectedOption: AppConfigurationOptions

    if case let .logged(settings) = loginState {
      connectedOption = .connectedToTrakt
      connectedConfiguration = AppConfigurationViewModel(title: "Connected".localized,
                                                         subtitle: settings.user.name,
                                                         value: .none)
    } else {
      connectedOption = .connectToTrakt
      connectedConfiguration = AppConfigurationViewModel(title: "Connect to Trakt".localized,
                                                         subtitle: nil,
                                                         value: .none)
    }

    let configurations = [connectedConfiguration]
    options.append(connectedOption)

    return AppConfigurationsViewModel(title: "Trakt", configurations: configurations)
  }

  private func generalConfigurationsViewModel(_ state: AppConfigurationsState) -> AppConfigurationsViewModel {
    let configurations = [AppConfigurationViewModel(title: "Hide specials",
                                                    subtitle: "Will not show special episodes",
                                                    value: .boolean(value: state.hideSpecials))]

    options.append(.hideSpecials)

    return AppConfigurationsViewModel(title: "General", configurations: configurations)
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
