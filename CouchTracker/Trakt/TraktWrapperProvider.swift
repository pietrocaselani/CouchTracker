import TraktSwift
import RxSwift
import Moya

final class TraktWrapperProvider: TraktProvider, TraktAuthenticationProvider {
	private let disposeBag = DisposeBag()
	private let trakt: Trakt

	var movies: MoyaProvider<Movies>

	var genres: MoyaProvider<Genres>

	var search: MoyaProvider<Search>

	var shows: MoyaProvider<Shows>

	var users: MoyaProvider<Users>

	var authentication: MoyaProvider<Authentication>

	var episodes: MoyaProvider<Episodes>

	var sync: MoyaProvider<Sync>

	var oauth: URL? {
		return trakt.oauth
	}

	var isAuthenticated: Bool {
		return trakt.hasValidToken
	}

	init(trakt: Trakt, loginObservable: TraktLoginObservable) {
		self.trakt = trakt

		self.movies = trakt.movies
		self.genres = trakt.genres
		self.search = trakt.search
		self.shows = trakt.shows
		self.users = trakt.users
		self.authentication = trakt.authentication
		self.episodes = trakt.episodes
		self.sync = trakt.sync

		loginObservable.observe().subscribe(onNext: { [unowned self] _ in
			self.refreshProviders()
		}).disposed(by: disposeBag)
	}

	func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
		return trakt.finishesAuthentication(with: request)
	}

	private func refreshProviders() {
		self.movies = trakt.movies
		self.genres = trakt.genres
		self.search = trakt.search
		self.shows = trakt.shows
		self.users = trakt.users
		self.authentication = trakt.authentication
		self.episodes = trakt.episodes
		self.sync = trakt.sync
	}
}
