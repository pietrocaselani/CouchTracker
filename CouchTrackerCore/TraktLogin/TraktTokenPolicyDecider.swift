import RxSwift
import TraktSwift

public final class TraktTokenPolicyDecider: TraktLoginPolicyDecider {
	private let trakt: TraktProvider
	private let output: TraktLoginOutput
	private let schedulers: Schedulers

	public init(loginOutput: TraktLoginOutput) {
		Swift.fatalError("Not implemented! Use init(loginOutput: traktProvider:)")
	}

	public init(loginOutput: TraktLoginOutput, traktProvider: TraktProvider, schedulers: Schedulers) {
		self.output = loginOutput
		self.trakt = traktProvider
		self.schedulers = schedulers
	}

	public func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult> {
		return trakt.finishesAuthentication(with: request)
			.observeOn(schedulers.mainScheduler)
			.do(onSuccess: { [unowned self] result in
				if result == AuthenticationResult.authenticated {
					self.output.loggedInSuccessfully()
				}
				}, onError: { [unowned self] error in
					self.output.logInFail(message: error.localizedDescription)
			})
	}
}
