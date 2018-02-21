import RxSwift

public final class TraktLoginService: TraktLoginInteractor {
	private let oauthURL: URL

	public init?(traktProvider: TraktProvider) {
		guard let url = traktProvider.oauth else {
			return nil
		}

		self.oauthURL = url
	}

	public func fetchLoginURL() -> Single<URL> {
		return Single.just(oauthURL)
	}
}
