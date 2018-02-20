import RxSwift
import TraktSwift

final class TraktTokenPolicyDecider: TraktLoginPolicyDecider {
	private let trakt: TraktProvider
	private let output: TraktLoginOutput

	init(loginOutput: TraktLoginOutput) {
		Swift.fatalError("Not implemented! Use init(loginOutput: traktProvider:)")
	}

	init(loginOutput: TraktLoginOutput, traktProvider: TraktProvider) {
		self.output = loginOutput
		self.trakt = traktProvider
	}

	func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult> {
		return trakt.finishesAuthentication(with: request)
			.observeOn(MainScheduler.instance)
			.do(onSuccess: { [unowned self] result in
				if result == AuthenticationResult.authenticated {
					self.output.loggedInSuccessfully()
				}
				}, onError: { [unowned self] error in
					self.output.logInFail(message: error.localizedDescription)
			})
	}
}
