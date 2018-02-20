import RealmSwift
import TraktSwift

final class EpisodeIdsRealm: Object {
	@objc dynamic var trakt = -1
	let tmdb = RealmOptional<Int>()
	@objc dynamic var imdb: String?
	@objc dynamic var tvdb = -1
	let tvrage = RealmOptional<Int>()

	override static func primaryKey() -> String? {
		return "trakt"
	}

	override func isEqual(_ object: Any?) -> Bool {
		guard let entity = object as? EpisodeIdsRealm else { return false }

		return self == entity
	}

	static func == (lhs: EpisodeIdsRealm, rhs: EpisodeIdsRealm) -> Bool {
		return lhs.trakt == rhs.trakt &&
			lhs.tmdb.value == rhs.tmdb.value &&
			lhs.imdb == rhs.imdb &&
			lhs.tvdb == rhs.tvdb &&
			lhs.tvrage.value == rhs.tvrage.value
	}

	func toEntity() -> EpisodeIds {
		return EpisodeIds(trakt: self.trakt,
											tmdb: self.tmdb.value,
											imdb: self.imdb,
											tvdb: self.tvdb,
											tvrage: self.tvrage.value)
	}
}

extension EpisodeIds {
	func toRealm() -> EpisodeIdsRealm {
		let entity = EpisodeIdsRealm()

		entity.trakt = self.trakt
		entity.tmdb.value = self.tmdb
		entity.imdb = self.imdb
		entity.tvdb = self.tvdb
		entity.tvrage.value = self.tvrage

		return entity
	}
}
