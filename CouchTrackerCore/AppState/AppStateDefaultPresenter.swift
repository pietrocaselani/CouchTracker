import RxSwift
import TraktSwift

private typealias Strings = CouchTrackerCoreStrings

public final class AppStateDefaultPresenter: AppStatePresenter {
  private let viewStateSubject = BehaviorSubject<AppStateViewState>(value: .loading)
  private let disposeBag = DisposeBag()
  private let schedulers: Schedulers
  private let router: AppStateRouter
  private let appStateManager: AppStateManager

  public init(router: AppStateRouter,
              appStateManager: AppStateManager,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.router = router
    self.schedulers = schedulers
    self.appStateManager = appStateManager
  }

  public func viewDidLoad() {
    updateView()
  }

  public func observeViewState() -> Observable<AppStateViewState> {
    viewStateSubject.distinctUntilChanged()
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
      toggleHideSpecials()
    }
  }

  private func toggleHideSpecials() {
    appStateManager.toggleHideSpecials()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onError: { [weak self] error in
        self?.router.showError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }

  private func updateView() {
    appStateManager.observe()
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

    appStateManager.observe()
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
      connectedConfiguration = AppConfigurationViewModel(title: Strings.connectedToTrakt(),
                                                         subtitle: settings.user.name,
                                                         value: .none)
    } else {
      connectedConfiguration = AppConfigurationViewModel(title: Strings.connectToTrakt(),
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
