@testable import CouchTrackerCore
import Moya
import RxSwift
import TraktSwift

final class AppStateMock {
  private init() {}

  static func createUserMock() -> User {
    return try! JSONDecoder().decode(Settings.self, from: Users.settings.sampleData).user
  }

  static func createUnauthorizedErrorMock() -> MoyaError {
    let response = Response(statusCode: 401, data: Data())
    return MoyaError.statusCode(response)
  }

  final class AppStateObservableMock: AppStateObservable {
    var subject = PublishSubject<AppState>()

    func change(state: AppState) {
      subject.onNext(state)
    }

    func observe() -> Observable<AppState> {
      return subject.asObservable()
    }
  }

  final class AppStateOutputMock: AppStateOutput {
    var newConfigurationInvoked = false
    var newConfigurationParameters: AppState?

    func newConfiguration(state: AppState) {
      newConfigurationInvoked = true
      newConfigurationParameters = state
    }
  }
}

final class AppStateInteractorErrorMock: AppStateInteractor {
  var error: Error!

  init(repository _: AppStateRepository, output _: AppStateOutput) {}

  func fetchAppState() -> Observable<AppState> {
    return Observable.error(error)
  }

  func toggleHideSpecials() -> Completable {
    return Completable.error(error)
  }
}

final class AppStateInteractorMock: AppStateInteractor {
  private let repository: AppStateRepository
  var hideSpecials = false
  var loginState = LoginState.notLogged
  var toggleHideSpecialsInvoked = false

  init(repository: AppStateRepository, output _: AppStateOutput) {
    self.repository = repository
  }

  func fetchAppState() -> Observable<AppState> {
    let hideSpecial = repository.fetchHideSpecials()
    let loginState = repository.fetchLoginState()

    return Observable.combineLatest(loginState, hideSpecial, resultSelector: { (loginState, hideSpecials) -> AppState in
      AppState(loginState: loginState, hideSpecials: hideSpecials)
    }).catchErrorJustReturn(AppState.initialState())
  }

  func toggleHideSpecials() -> Completable {
    toggleHideSpecialsInvoked = true
    return repository.toggleHideSpecials()
  }
}

final class AppStateRouterMock: AppStateRouter {
  var invokedShowTraktLogin = false
  var invokedShowErrorMessage = false
  var invokedShowErrorMessageParameters: (message: String, Void)?
  var showExternalURLInvokedCount = 0
  var showExternalURLLastParameter: URL?

  func showTraktLogin(output _: TraktLoginOutput) {
    invokedShowTraktLogin = true
  }

  func showExternal(url: URL) {
    showExternalURLInvokedCount += 1
    showExternalURLLastParameter = url
  }

  func showError(message: String) {
    invokedShowErrorMessage = true
    invokedShowErrorMessageParameters = (message, ())
  }
}

final class AppStateRepositoryMock: AppStateRepository {
  private let usersProvider: MoyaProvider<Users>
  private let isEmpty: Bool
  var invokedSaveSettings = false
  var invokedFetchSettings = false
  var hideSpecials = false
  var invokedToggleHideSpecials = false
  var invokedFetchHideSpecials = false

  init(usersProvider: MoyaProvider<Users>, isEmpty: Bool = false, dataSource _: AppStateDataSource = AppConfigurationDataSourceMock(settings: nil)) {
    self.usersProvider = usersProvider
    self.isEmpty = isEmpty
  }

  func fetchHideSpecials() -> Observable<Bool> {
    invokedFetchHideSpecials = true
    return Observable.just(hideSpecials)
  }

  func toggleHideSpecials() -> Completable {
    invokedToggleHideSpecials = true
    hideSpecials = !hideSpecials
    return Completable.empty()
  }

  func fetchLoginState() -> Observable<LoginState> {
    invokedFetchSettings = true

    guard !isEmpty else { return Observable.just(LoginState.notLogged) }

    return usersProvider.rx.request(.settings).map(Settings.self).asObservable().map { LoginState.logged(settings: $0) }
  }
}

final class AppStateRepositoryErrorMock: AppStateRepository {
  private let error: Swift.Error?
  private let loginError: Swift.Error?

  init(error: Swift.Error? = nil, loginError: Swift.Error? = nil) {
    self.error = error
    self.loginError = loginError
  }

  func fetchLoginState() -> Observable<LoginState> {
    if let error = error {
      return Observable.error(error)
    }

    if let error = loginError {
      return Observable.error(error)
    }

    return Observable.just(LoginState.notLogged)
  }

  func fetchHideSpecials() -> Observable<Bool> {
    if let error = error {
      return Observable.error(error)
    }

    return Observable.just(false)
  }

  func toggleHideSpecials() -> Completable {
    if let error = error {
      return Completable.error(error)
    }

    return Completable.empty()
  }
}

final class AppConfigurationDataSourceMock: AppStateDataSource {
  var invokedSaveSettings = false
  var invokedFetchLoginState = false
  var hideSpecials = false
  var invokedToggleHideSpecials = false
  var invokedFetchHideSpecials = false
  var settings: Settings?
  private let loginStateSubject: BehaviorSubject<LoginState>

  init(settings: Settings?) {
    self.settings = settings

    let state: LoginState

    if let settings = settings {
      state = LoginState.logged(settings: settings)
    } else {
      state = .notLogged
    }

    loginStateSubject = BehaviorSubject<LoginState>(value: state)
  }

  func save(settings: Settings) throws {
    invokedSaveSettings = true
    self.settings = settings

    DispatchQueue.main.async {
      self.loginStateSubject.onNext(.logged(settings: settings))
    }
  }

  func fetchLoginState() -> Observable<LoginState> {
    invokedFetchLoginState = true
    return loginStateSubject.asObservable()
  }

  func toggleHideSpecials() throws {
    invokedToggleHideSpecials = true
    hideSpecials = !hideSpecials
  }

  func fetchHideSpecials() -> Observable<Bool> {
    invokedFetchHideSpecials = true
    return Observable.just(hideSpecials)
  }
}

final class AppStateDataSourceErrorMock: AppStateDataSource {
  private let error: Error
  var saveSettingsInvoked = false

  init(error: Error) {
    self.error = error
  }

  func save(settings _: Settings) throws {
    saveSettingsInvoked = true
    throw error
  }

  func fetchLoginState() -> Observable<LoginState> {
    return Observable.error(error)
  }

  func toggleHideSpecials() throws {
    throw error
  }

  func fetchHideSpecials() -> Observable<Bool> {
    return Observable.error(error)
  }
}

final class AppStateNetworkMock: AppStateNetwork {
  var fetchUserSettingsInvoked = false
  var fetchUserSettingsInvokedCount = 0

  func fetchUserSettings() -> Single<Settings> {
    fetchUserSettingsInvoked = true
    fetchUserSettingsInvokedCount += 1

    let settings = TraktEntitiesMock.createUserSettingsMock()
    return Single.just(settings)
  }
}
