import RxSwift

final class TraktLoginOutputMock: TraktLoginOutput {
	var invokedLoggedInSuccessfully = false
	var invokedLogInFail = false
	var invokedLoginFailParameters: (message: String, Void)?

	func loggedInSuccessfully() {
		invokedLoggedInSuccessfully = true
	}

	func logInFail(message: String) {
		invokedLogInFail = true
		invokedLoginFailParameters = (message, ())
	}
}

final class TraktLoginErrorInteractorMock: TraktLoginInteractor {
	private let error: Error
	init(traktProvider: TraktProvider = TraktProviderMock(), error: Error) {
		self.error = error
	}

	init(traktProvider: TraktProvider) {
		fatalError("Please, use init(traktProvider: error:)")
	}

	func fetchLoginURL() -> Single<URL> {
		return Single.error(error)
	}
}

final class TraktLoginInteractorMock: TraktLoginInteractor {
	private let url: URL

	init(traktProvider: TraktProvider) {
		guard let oauthURL = traktProvider.oauth else {
			fatalError("Impossible to create oauthURL without a redirect URL.")
		}

		self.url = oauthURL
	}

	func fetchLoginURL() -> Single<URL> {
		return Single.just(url)
	}
}

final class TraktLoginViewMock: TraktLoginView {
	var policyDecider: TraktLoginPolicyDecider!
	var presenter: TraktLoginPresenter!

	var invokedLoadLogin = false
	var invokedLoadLoginParameters: (url: URL, Void)?

	func loadLogin(using url: URL) {
		invokedLoadLogin = true
		invokedLoadLoginParameters = (url, ())
	}
}
