@testable import CouchTrackerCore
import Moya
import RxSwift
import TraktSwift

enum AppStateMock {
  static func createUserMock() -> User {
    return createSettingsMock().user
  }

  static func createSettingsMock() -> Settings {
    return try! JSONDecoder().decode(Settings.self, from: Users.settings.sampleData)
  }

  static let loggedAppState = AppState(userSettings: createSettingsMock(), hideSpecials: true)

  static func createUnauthorizedErrorMock() -> MoyaError {
    let response = Response(statusCode: 401, data: Data())
    return MoyaError.statusCode(response)
  }

  final class AppStateManagerMock: AppStateManager {
    let subject: BehaviorSubject<AppState>
    let error: Error?
    var toggleHideSpecialsInvokeCount = 0
    var loginInvokeCount = 0
    var loginURLInvokeCount = 0

    init(appState: AppState = AppState.initialState(), error: Error? = nil) {
      subject = BehaviorSubject<AppState>(value: appState)
      self.error = error
    }

    func login() -> Completable {
      loginInvokeCount += 1
      return Completable.empty()
    }

    func toggleHideSpecials() -> Completable {
      toggleHideSpecialsInvokeCount += 1
      guard let realError = error else {
        return Completable.empty()
      }
      return Completable.error(realError)
    }

    func loginURL() -> Single<URL> {
      loginURLInvokeCount += 1
      return Single.just(URL(string: "https://google.com")!)
    }

    func observe() -> Observable<AppState> {
      return subject.asObservable()
    }

    func change(state: AppState) {
      subject.onNext(state)
    }
  }

  final class AppStateObservableMock: AppStateObservable {
    var subject: BehaviorSubject<AppState>

    init(appState: AppState = AppState.initialState()) {
      subject = BehaviorSubject(value: appState)
    }

    func change(state: AppState) {
      subject.onNext(state)
    }

    func observe() -> Observable<AppState> {
      return subject.asObservable()
    }
  }

  final class DataHolderMock: AppStateDataHolder {
    private var appState = AppState.initialState()

    func currentAppState() throws -> AppState {
      return appState
    }

    func save(appState: AppState) throws {
      self.appState = appState
    }
  }
}

final class AppStateRouterMock: AppStateRouter {
  var invokedShowTraktLogin = false
  var invokedFinishTraktLogin = false
  var invokedShowErrorMessage = false
  var invokedShowErrorMessageParameters: (message: String, Void)?
  var showExternalURLInvokedCount = 0
  var showExternalURLLastParameter: URL?

  func showTraktLogin() {
    invokedShowTraktLogin = true
  }

  func finishLogin() {
    invokedFinishTraktLogin = true
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
