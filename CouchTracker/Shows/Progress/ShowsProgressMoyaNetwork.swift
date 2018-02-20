import RxSwift
import TraktSwift

final class ShowsProgressMoyaNetwork: ShowsProgressNetwork {
	private let trakt: TraktProvider

	init(trakt: TraktProvider) {
		self.trakt = trakt
	}

	func fetchWatchedShows(extended: Extended) -> Single<[BaseShow]> {
		let target = Sync.watched(type: .shows, extended: extended)
		return trakt.sync.rx.request(target).map([BaseShow].self)
	}
}
