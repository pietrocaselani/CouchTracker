import RealmSwift
import TraktSwift

public final class EpisodeIdsRealm: Object {
	@objc public dynamic var trakt = -1
	public let tmdb = RealmOptional<Int>()
	@objc public dynamic var imdb: String?
	@objc public dynamic var tvdb = -1
	public let tvrage = RealmOptional<Int>()

	override public static func primaryKey() -> String? {
		return "trakt"
	}

	override public func isEqual(_ object: Any?) -> Bool {
		guard let entity = object as? EpisodeIdsRealm else { return false }

		return self == entity
	}

	public static func == (lhs: EpisodeIdsRealm, rhs: EpisodeIdsRealm) -> Bool {
		return lhs.trakt == rhs.trakt &&
			lhs.tmdb.value == rhs.tmdb.value &&
			lhs.imdb == rhs.imdb &&
			lhs.tvdb == rhs.tvdb &&
			lhs.tvrage.value == rhs.tvrage.value
	}

	public func toEntity() -> EpisodeIds {
		return EpisodeIds(trakt: self.trakt,
											tmdb: self.tmdb.value,
											imdb: self.imdb,
											tvdb: self.tvdb,
											tvrage: self.tvrage.value)
	}
}

public extension EpisodeIds {
	public func toRealm() -> EpisodeIdsRealm {
		let entity = EpisodeIdsRealm()

		entity.trakt = self.trakt
		entity.tmdb.value = self.tmdb
		entity.imdb = self.imdb
		entity.tvdb = self.tvdb
		entity.tvrage.value = self.tvrage

		return entity
	}
}
