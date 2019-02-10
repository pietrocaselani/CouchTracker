@testable import CouchTrackerCore
import Moya
import RxSwift
import TraktSwift

enum AppStateMock {
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

final class AppStateInteractorErrorMock: AppStateInteractor {
  var error: Error!

  func fetchAppState() -> Observable<AppState> {
    return Observable.error(error)
  }

  func toggleHideSpecials() -> Completable {
    return Completable.error(error)
  }
}

final class AppStateInteractorMock: AppStateInteractor {
  var toggleHideSpecialsInvoked = false
  private var appState = AppState.initialState()

  func fetchAppState() -> Observable<AppState> {
    return Observable.just(appState)
  }

  func toggleHideSpecials() -> Completable {
    toggleHideSpecialsInvoked = true
    return Completable.empty()
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
